#!/bin/bash
## Build the TURNUS eclipse enviroment by command line

NBARGS=2
function print_usage() {
    echo "Usage: $0 <workspace> <turnus_plugins_repository>"
    echo "    <workspace>       The directory where eclipe will be extracted and plugins istalled"
    echo "    <turnus_plugins>  The directory where you have dowloaded and builded all the turnus plugins"
}

if [ $# -lt $NBARGS ]; then
    print_usage
    exit $E_BADARGS
fi


# The Eclipse download url. If you want to change the mirror just select one from http://mirror.switch.ch/eclipse/technology/epp/downloads/release/neon/2
ECLIPSE_DOWNLOAD_URL="http://mirror.switch.ch/eclipse/technology/epp/downloads/release/neon/2/eclipse-rcp-neon-2-linux-gtk-x86_64.tar.gz"
# The TURNUS required features
FEATURES="turnus.feature.feature.group"
FEATURES="$FEATURES,turnus.orcc.feature.feature.group"

# The eclipse directory (e.g. /home/scb/Development/test/eclipse )
ECLIPSE_DIR=$1
# The turnus eclipse plugins respository directory (e.g. where you have downloaded all the turnus plugins)
TURNUS_PATH=$2/turnus.p2/turnus.site/target/repository/
## clean the path name and remove '//' strings
TURNUS_PATH=$(readlink -m "$TURNUS_PATH") 

if [ ! -d "$TURNUS_PATH" ]; then
  echo "the turnus plugins are not compiled, please launch build_plugins.sh before"
  exit $E_BADARGS
fi

echo "***START*** $0 $(date -R)"

if [ -d "$ECLIPSE_DIR" ]; then
  echo "Cleaning the eclipse directory"
  rm -rf $ECLIPSE_DIR
fi

echo "Creating an empty eclipse directory"
mkdir $ECLIPSE_DIR

echo "Downloading Eclipse"
wget --progress=dot:mega $ECLIPSE_DOWNLOAD_URL

ECLIPSEARCHIVE=$(echo eclipse-rcp-*.tar.gz)

echo "Uncompressing Eclipse archive"
tar -xzaf $ECLIPSEARCHIVE
# copy it in the right directory
cp -r eclipse/* $ECLIPSE_DIR

echo "Deleting downloaded archives"
rm -rf eclipse
rm $ECLIPSEARCHIVE

echo "Installing the TURNUS plugins"
echo "$ECLIPSE_DIR/eclipse   -nosplash -consoleLog \
                        -application org.eclipse.equinox.p2.director \
                        -repository $TURNUS_PATH \
                        -followReferences \
                        -installIU $FEATURES"

$ECLIPSE_DIR/eclipse   -nosplash -consoleLog \
                        -application org.eclipse.equinox.p2.director \
                        -repository file:/$TURNUS_PATH \
                        -followReferences \
                        -installIU $FEATURES

echo "***END*** $0 $(date -R)"
