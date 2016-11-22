#!/bin/bash
## Build the TURNUS eclipse plugins by command line

NBARGS=1
function print_usage() {
    echo "Usage: $0 <workspace> <empty_maven_repository>"
    echo "    <workspace>         The directory where plugins are builded"
    echo "    <maven_repository>  (optional) the local maven repository path (current data will be erased)"
}

if [ $# -lt $NBARGS ]; then
    print_usage
    exit $E_BADARGS
fi

WORKSPACE=$1
MAVEN=$2
 

if [ ! -d "$WORKSPACE" ]; then
	mkdir -p $WORKSPACE
fi

if [ -n "$MAVEN" ]; then
	if [ ! -d "$MAVEN" ]; then
		mkdir -p $MAVEN
	else
		rm -fR $MAVEN/*
	fi
fi

cd $WORKSPACE
rm -fR turnus*

git clone https://github.com/turnus/turnus.git
git clone https://github.com/turnus/turnus.core.git
git clone https://github.com/turnus/turnus.orcc.git
git clone https://github.com/turnus/turnus.p2.git
cd turnus.p2

# create if necessary the maven repository directory
if [ -z "$MAVEN" ]; then
	mvn clean install -Dtycho.localArtifacts=ignore
else
	mvn clean install -Dtycho.localArtifacts=ignore -Dmaven.repo.local=$MAVEN
fi

echo "***END*** $0 $(date -R)"
