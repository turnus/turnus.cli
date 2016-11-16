#!/bin/bash
## Run the TURNUS Orcc dynamic execution profiler

CAL_PROJECT_ARG="-calProject" # the cal project argument required by the profiler

NBARGS=3
function print_usage() {
    echo
    echo "Usage: $0 <eclipse_directory> <projects_dir> <args>"
    echo "    <eclipse_directory>           The directory where Eclipse is installed"
    echo "    <projects_dir>                The directory where CAL projects are located"
    echo "    <args>                        The profiler arguments"
}

if [ $# -lt $NBARGS ]; then
    print_usage
    exit $E_BADARGS
fi

# Find the project name. This will be used to build the Orcc IR
array=( "$@" )
arraylength=${#array[@]}
for (( i=0; i<${arraylength}; i++ ));
do
   if [ "${array[$i]}" == $CAL_PROJECT_ARG ]; then
     PROJECT_NAME="${array[$i+1]}"
   fi
done

if [ -z "$PROJECT_NAME" ]; then
  echo "The cal project name is not set. use $CAL_PROJECT_ARG argument";
  exit $E_BADARGS
fi

ECLIPSE_DIR=$1
PROJECTS_DIR=$2

for arg in "${*:3}"
  do ARGUMENTS="$ARGUMENTS $arg"
done

echo "***START*** $0 $(date -R)"

RUNWORKSPACE=$PROJECTS_DIR
rm -fr $RUNWORKSPACE/.metadata $RUNWORKSPACE/.JETEmitters
rm -fr $RUNWORKSPACE/**/bin

echo "Register Orcc projects in eclipse workspace"
$ECLIPSE_DIR/eclipse    -nosplash -consoleLog \
                        -application net.sf.orcc.cal.workspaceSetup \
                        -data $RUNWORKSPACE \
                        $PROJECTS_DIR

echo "Generate Orcc IR for $PROJECT_NAME and projects it depends on"
$ECLIPSE_DIR/eclipse    -nosplash -consoleLog \
                        -application net.sf.orcc.cal.cli \
                        -data $RUNWORKSPACE \
                        $PROJECT_NAME

echo "Running the dynamic execution analysis of $PROJECT_NAME with the following arguments: $ARGUMENTS"
$ECLIPSE_DIR/eclipse     -nosplash -consoleLog \
                         -application turnus.orcc.profiler.dynamicExecution \
                         -data $RUNWORKSPACE \
                         $ARGUMENTS

echo "***END*** $0 $(date -R)"
