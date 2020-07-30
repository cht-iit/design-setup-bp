#!/bin/bash

ROOT="$ROBOT_CODE/design-setup-bp"
FOLDER="$ROOT/data-analysis/nominal-pose"
TARGET="$FOLDER/target_list.txt"
NREP=3

i=0
while IFS= read -r line
do
  
  mkdir -p $FOLDER/target_"${i}"
  echo $line >> $FOLDER/target_"${i}"/target.log
  
  for (( j=0; j<$NREP; j++ ))
    do
      echo "Analyzing target the "$j" time"
      yarp wait /actionsRenderingEngine/cmd:io
      echo "home all" | yarp rpc /actionsRenderingEngine/cmd:io
      ack=$(echo "grasp (cartesian $line) left still (approach (0.0 0.0 0.07 0.0))" | yarp rpc /actionsRenderingEngine/cmd:io | awk -F'[][]' '{print $2}')
       
      if [ $ack == "nack" ]; then
        echo "Motion done!"

        (cd $FOLDER && yarpdatadumper --connect /icubSim/cartesianController/left_arm/state:o --name target_"${i}"/pose_"${j}" &)
        (cd $FOLDER && yarpdatadumper --connect /icubSim/left_arm/state:o --name target_"${i}"/left_arm_"${j}" &)
        (cd $FOLDER && yarpdatadumper --connect /icubSim/torso/state:o --name target_"${i}"/torso_"${j}" &)

        sleep 3
        killall -9 yarpdatadumper
        sleep 2
      fi
  done
  i=$((i+1))
done < "$TARGET"

