#!/bin/bash
## Build the TURNUS eclipse enviroment by command line

NBARGS=2
function print_usage() {
    echo
    echo "Usage: $0 <eclipse_directory> <repository_url>"
    echo "    <eclipse_directory>           The directory where Eclipse will be installed"
    echo "    <repository_url>              The repository URL (e.g. http://eclipse.turnus.co or file:/user/local/path)"
}

if [ $# -lt $NBARGS ]; then
    print_usage
    exit $E_BADARGS
fi

# The Eclipse download url (if you want to change the mirror just select one from https://eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/mars/R/eclipse-rcp-mars-R-linux-gtk-x86_64.tar.gz&format=xml )
ECLIPSE_DOWNLOAD_URL="http://mirror.switch.ch/eclipse/technology/epp/downloads/release/mars/R/eclipse-rcp-mars-R-linux-gtk-x86_64.tar.gz"
# The TURNUS required features
FEATURES="turnus.feature.feature.group"
FEATURES="$FEATURES,turnus.neo4j.feature.feature.group"
FEATURES="$FEATURES,turnus.orcc.feature.feature.group"

# The eclipse directory (e.g. /home/scb/Development/test/eclipse )
ECLIPSE_DIR=$1
# The turnus eclipse p2 plugins respository site (e.g. file:/home/scb/development/turnus.p2/turnus.site/target/repository/)
TURNUS_P2=$2

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

echo "Downloading and installing the TURNUS plugins"
$ECLIPSE_DIR/eclipse   -nosplash -consoleLog \
                        -application org.eclipse.equinox.p2.director \
                        -repository $TURNUS_P2 \
                        -followReferences \
                        -installIU $FEATURES

echo "***END*** $0 $(date -R)"
