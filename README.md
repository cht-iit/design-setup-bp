# Setup gazebo Boggiano Pico



## Installation :gear:

For using the simulated environment contained in this repository you have to install

- [`YARP`](https://www.yarp.it/install.html)
- [`icub-main`](https://wiki.icub.org/wiki/ICub_Software_Installation)
- [`gazebo`](http://gazebosim.org/tutorials?tut=install_ubuntu)
- [`gazebo-yarp-plugins`](https://github.com/robotology/gazebo-yarp-plugins/blob/master/doc/install.md)
- [`icub-gazebo`](https://github.com/robotology/icub-gazebo)

Alternatively it is possible to install all the dependencies via the [`robotology-superbuild`](https://github.com/robotology/robotology-superbuild#installation) enabling the [`ROBOTOLOGY_USES_GAZEBO`](https://github.com/robotology/robotology-superbuild#gazebo) profile.

Since this repo contains only `gazebo` models/world and `yarpmanager` scripts, compilation and installation is not required, it just need to export the environmental variables `GAZEBO_RESOURCE_PATH` pointing where the [`BP-setup.world`](https://github.com/icub-tech-iit/setup-gazebo-bp/tree/master/models/gazebo/worlds) is contained and `GAZEBO_MODEL_PATH` pointing where the models are contained(e.g [here](https://github.com/icub-tech-iit/setup-gazebo-bp/tree/master/models/setup-gazebo-bp/robots)).

## Demo :rocket:

- Run `yarpserver`
- Run `yarpmanager` and open the [`actionsRenderingEngineSim.xml`](https://github.com/icub-tech-iit/setup-gazebo-bp/blob/master/scripts/actionsRenderingEngineSim.xml) application and run all.
- After all the executable are up and running open a terminal and run `yarp rpc /ActionsRenderingEngine/cmd:io` and type the command `grasp ("cartesian" -0.5 -0.1 -0.1 0.0 0.0 1.0 3.14) left`.