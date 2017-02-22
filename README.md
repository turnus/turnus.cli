# turnus.cli

Build, launch and continuous integration scripts for TURNUS

## Build 

In order to build the Eclipse worskpace by command line use the scripts located in the ```build``` directory of this repository:
- ```build_plugins.sh``` used to build all the turnus plugins
- ```build_eclipse.sh``` used to download Eclipse and install the builded turnus plugins

As an example, we define two paths: ```TURNUS_HOME``` where the plugins will be downloaded and duilded, and ```ECLIPSE_HOME``` where eclipse will be dowloaded and the builded plugins installed. Then you have to run the two scripts as follows:
```
export TURNUS_HOME="~/turnus/"
export ECLIPSE_HOME="~/eclipse/"
./build_plugins.sh $TURNUS_HOME
./build_eclipse.sh $ECLIPSE_HOME $TURNUS_HOME
```

