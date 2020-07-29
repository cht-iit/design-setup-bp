#!/bin/bash

yarpserver --write --silent &
gazebo BP-setup-drop.world &

sleep 5
yarp wait /icubSim/torso/state:o
yarp wait /icubSim/head/state:o
yarp wait /icubSim/left_arm/state:o
yarp wait /icubSim/right_arm/state:o

yarpmanager-console --application experiment.xml --run --connect --exit --silent
yarp wait /actionsRenderingEngine/cmd:io
echo "home all" | yarp rpc /actionsRenderingEngine/cmd:io
echo "grasp (cartesian -0.3 -0.3 -0.05 0.0 0.0 1.0 3.49066) (approach (0.0 0.0 0.07 0.0)) left still" | yarp rpc /actionsRenderingEngine/cmd:io

declare -a modules=("actionsRenderingEngine" "wholeBodyDynamics" "iKinGazeCtrl" "iKinCartesianSolver" "yarprobotinterface" "gzclient" "gzserver" "yarpserver")
for module in ${modules[@]}; do
  sleep 3
  killall ${module}
done

