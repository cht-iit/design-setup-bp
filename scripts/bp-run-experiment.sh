#!/bin/bash

yarpserver --write --silent &
gazebo BP-setup.world &

sleep 5
yarp wait /icubSim/torso/state:o
yarp wait /icubSim/head/state:o
yarp wait /icubSim/left_arm/state:o
yarp wait /icubSim/right_arm/state:o

yarpmanager-console --application ${ICUBcontrib_DIR}/share/ICUBcontrib/applications/bp-experiment.xml --run --connect --exit --silent
yarp wait /actionsRenderingEngine/cmd:io
echo "home all" | yarp rpc /actionsRenderingEngine/cmd:io
echo "grasp (cartesian -0.35 0.0 -0.05 0.0 0.0 1.0 3.14159) (approach (0.0 0.0 0.07 0.0)) left still" | yarp rpc /actionsRenderingEngine/cmd:io

sleep 5
killall actionsRenderingEngine
sleep 5
killall wholeBodyDynamics

sleep 5
declare -a modules=("iKinGazeCtrl" "iKinCartesianSolver" "yarprobotinterface")
for module in ${modules[@]}; do
  killall ${module}
done

sleep 5
declare -a modules=("gzclient" "gzserver" "yarpserver")
for module in ${modules[@]}; do
  killall ${module}
done

