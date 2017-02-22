# turnus.cli

Build, launch and continuous integration scripts for TURNUS

## Build 

The ```build``` directory contains the script to build a scriptable and command line enviroment of turnus:
- ```build_plugins.sh``` used to build all the turnus plugins
- ```build_eclipse.sh``` used to download Eclipse and install the builded turnus plugins

As an example, we define two paths: ```TURNUS_HOME``` where the plugins will be downloaded and duilded, and ```ECLIPSE_HOME``` where eclipse will be dowloaded and the builded plugins installed. Then you have to run the two scripts as follows:
```
export TURNUS_HOME="~/turnus/"
export ECLIPSE_HOME="~/eclipse/"
./build_plugins.sh $TURNUS_HOME
./build_eclipse.sh $ECLIPSE_HOME $TURNUS_HOME
```

## Profiler
The ```profiler``` directory contains the script used to launch by command line the turnus profilers
- ```run_orcc_code_analysis.sh```
- ```run_orcc_dynamic_execution.sh```
- ```run_orcc_dynamic_interpreter.sh```
- ```run_orcc_dynamic_numa.sh```

In the following it is supposed that you clone the [cal-examples](https://github.com/turnus/cal-examples) git repository in the directory ```CAL_APPS```. As an example, to launch the Orcc dynamic interpreter run the corresponding script as follows:

```
export CAL_APPS="~/cal-examples"
export ECLIPSE_HOME="~/eclipse/"
./run_orcc_dynamic_interpreter.sh $ECLIPSE_HOME $CAL_APPS -calProject HelloWorld -xdf src/Example.xdf -scheduler RoundRobin -out ~/turnus_out
```

 
