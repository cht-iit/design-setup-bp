# Setup Gazebo Boggiano Pico
This repository contains the software required to optimize the dimensions of the setup which will be used to perform a specific [HRI experiment](./documents/experimental-protocol.pdf) with the iCub. Such setup consists of a standard height table (`~75cm`), containing a drawer with a `8cm x 8cm x 8cm` box placed in the middle, as shown in the following:

<p align="center">
<img src="https://user-images.githubusercontent.com/9716288/88031776-5d7ae480-cb3d-11ea-9967-af5954de04e4.png" width="400">
</p>

The final aim is to provide the Mechanical Workshop Unit (MWS) with the optimal sizes of the table (i.e. length and width) and the drawer (i.e. length, width and height).
To do so, the 3D meshes of the setup will be imported in the `Gazebo` simulation environment and the iCub will be programmed to touch the object inside the drawer. The table and drawer parameters will be optimized in order to maximize the robot reachability to the box, while guaranteeing a safe interaction with the drawer.

☝🏻 Importantly, the iCub will be executing predefined movements without relying on its percepetive capabilities.

The following image shows a first example of the simulated interaction:

<p align="center">
<img src="https://user-images.githubusercontent.com/9716288/87792442-32924700-c844-11ea-902b-46983301e81e.gif" width="700">
</p>

## Installation :gear:
For using the simulated environment contained in this repository you have to install:
- [`YARP`](https://www.yarp.it/install.html)
- [`icub-main`](https://wiki.icub.org/wiki/ICub_Software_Installation)
- [`gazebo`](http://gazebosim.org/tutorials?tut=install_ubuntu)
- [`gazebo-yarp-plugins`](https://github.com/robotology/gazebo-yarp-plugins/blob/master/doc/install.md)
- [`icub-gazebo`](https://github.com/robotology/icub-gazebo)

Alternatively, it is possible to install all the dependencies via the [`robotology-superbuild`](https://github.com/robotology/robotology-superbuild#installation) enabling the [`ROBOTOLOGY_USES_GAZEBO`](https://github.com/robotology/robotology-superbuild#gazebo) profile.

Since this repo contains only `gazebo` models/world and `yarpmanager` scripts, compilation and installation are not required: it is just needed to export/extend the environmental variables:
- `GAZEBO_RESOURCE_PATH` – let it point **also** to where the [`BP-setup.world`](./models/gazebo/worlds) is located.
- `GAZEBO_MODEL_PATH` – let it point **also** to where [models are located](./models/setup-gazebo-bp/robots).


## Demo :rocket:
1. Run `yarpserver`.
1. Run `yarpmanager`.
1. Open the [`actionsRenderingEngineSim.xml`](./scripts/actionsRenderingEngineSim.xml) application and select `Run all`.
1. Check that all executables are up and running.
1. Open a terminal and launch:
   ```sh
   $ yarp rpc /ActionsRenderingEngine/cmd:io
   >> grasp ("cartesian" -0.5 -0.1 -0.1 0.0 0.0 1.0 3.14) left
   ```
