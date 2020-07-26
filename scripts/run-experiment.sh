#!/bin/bash

yarpserver --write --silent &
gazebo BP-setup.world &

sleep 5
yarp wait /icubSim/torso/state:o
yarp wait /icubSim/head/state:o
yarp wait /icubSim/left_arm/state:o
yarp wait /icubSim/right_arm/state:o

yarpmanager-console --application experiment.xml --run --connect --exit --silent
yarp wait /actionsRenderingEngine/cmd:io
echo "home all" | yarp rpc /actionsRenderingEngine/cmd:io
echo "grasp (cartesian -0.45 0.0 0.0 0.0 0.0 1.0 3.14159) left still" | yarp rpc /actionsRenderingEngine/cmd:io

declare -a modules=("actionsRenderingEngine" "wholeBodyDynamics" "iKinGazeCtrl" "iKinCartesianSolver" "yarprobotinterface" "gzclient" "gzserver" "yarpserver")
for module in ${modules[@]}; do
  sleep 3
  killall ${module}
done