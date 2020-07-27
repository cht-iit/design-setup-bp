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
<img src="https://user-images.githubusercontent.com/3738070/88289196-2bac7e00-ccf5-11ea-9a36-fe0fc19d7817.gif" width="700">
</p>

## Installation :gear:
For using the simulated environment contained in this repository you have to install:
- [`YARP`](https://www.yarp.it/install.html)
- [`icub-main`](https://wiki.icub.org/wiki/ICub_Software_Installation)
- [`icub-contrib-common`](https://wiki.icub.org/wiki/ICub_Software_Installation)
- [`gazebo`](http://gazebosim.org/tutorials?tut=install_ubuntu)
- [`gazebo-yarp-plugins`](https://github.com/robotology/gazebo-yarp-plugins/blob/master/doc/install.md)
- [`icub-models`](https://github.com/robotology/icub-models)

Alternatively, it is possible to install all the dependencies via the [`robotology-superbuild`](https://github.com/robotology/robotology-superbuild#installation) enabling the [`ROBOTOLOGY_USES_GAZEBO`](https://github.com/robotology/robotology-superbuild#gazebo) profile.

Once done, build and install the project:
```sh
$ mkdir build && cd build
$ cmake ../
$ make install
```

This will install the simulation assets and the world files under the location managed by the `icub-contrib-common` package (let's name it `ICUBcontrib_DIR` for later reference).

Finally, it is required to export/extend the following environmental variables:
- `GAZEBO_MODEL_PATH` – let it point **also** to `${ICUBcontrib_DIR}/share/setup-gazebo-bp/robots`.

## How to Run :rocket:
Simply launch the script [`run-experiment.sh`](./scripts/run-experiment.sh).

## Cloud IDE
You may consider exploring the Gitpod workspace associated to this repo by cliking on the following badge:

[![Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/icub-tech-iit/setup-gazebo-bp)

🔘 Find out more on [YARP-enabled Gitpod workspaces][1].

[1]: https://spectrum.chat/icub/technicalities/yarp-enabled-gitpod-workspaces-available~73ab5ee9-830e-4b7f-9e99-195295bb5e34
