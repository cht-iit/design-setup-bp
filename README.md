Design Boggiano Pico Setup
==========================

This repository contains the software required to optimize the dimensions of the setup which will be used by the [S4HRI](https://iit.it/research/lines/social-cognition-in-human-robot-interaction) Research Line at IIT to perform a specific [HRI experiment](./documents/experimental-protocol.pdf) with the iCub. Such setup consists of a standard height table (`~75cm`), containing a drawer with a `8cm x 8cm x 8cm` box placed in the middle, as shown in the following:

<p align="center">
<img src="https://user-images.githubusercontent.com/9716288/88031776-5d7ae480-cb3d-11ea-9967-af5954de04e4.png" width="400">
</p>

The final aim is to provide the [Mechanical Workshop (MWS)](https://iit.it/research/facilities/mechanical-workshop) of IIT with the optimal sizes of the table (i.e. length and width) and the drawer (i.e. length, width and height).
To do so, the 3D meshes of the setup will be imported in the `Gazebo` simulation environment and the iCub will be programmed to touch the object inside the drawer. The table and drawer parameters will be optimized in order to maximize the robot reachability to the box, while guaranteeing a safe interaction with the drawer.

⚠ Importantly, the iCub will be executing predefined movements without relying on its perceptive capabilities 👀❌

The animation below shows iCub performing the experiment with the setup resulting from this design:

<p align="center">
<img src="./assets/showcase.gif" width="700">
</p>

## ⚙ Installation
For using the simulated environment contained in this repository you have to install:
- [`YARP`](https://www.yarp.it/install.html)
- [`icub-main`](https://wiki.icub.org/wiki/ICub_Software_Installation)
- [`icub-contrib-common`](https://wiki.icub.org/wiki/ICub_Software_Installation)
- [`gazebo`](http://gazebosim.org/tutorials?tut=install_ubuntu) >= 11
- [`gazebo-yarp-plugins`](https://github.com/robotology/gazebo-yarp-plugins/blob/master/doc/install.md)
- [`icub-models`](https://github.com/robotology/icub-models)

Alternatively, it is possible to install all the dependencies via the [`robotology-superbuild`](https://github.com/robotology/robotology-superbuild#installation) enabling the [`ROBOTOLOGY_USES_GAZEBO`](https://github.com/robotology/robotology-superbuild#gazebo) profile.

Once done, build and install the project:
```sh
$ mkdir build && cd build
$ cmake ../
$ make install
```

## ☁ Cloud IDE
You may consider exploring the Gitpod workspace associated to this repo by clicking on the following badge:

[![Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/cht-iit/design-setup-bp)

🔘 Find out more on [YARP-enabled Gitpod workspaces][1].

## 🚀 How to Run
- For running the main experiment, simply launch the script [`bp-run-experiment.sh`](./scripts/bp-run-experiment.sh).
- To test a possible and comfortable pick/drop pose, launch the script [`bp-run-drop.sh`](./scripts/bp-run-drop.sh).

## 📐 Design of experiment and dimensions optimization
The detailed analysis that led us to choose the best dimensions of the table and the drawer can be found [📑 here](report.md).

[1]: https://spectrum.chat/icub/technicalities/yarp-enabled-gitpod-workspaces-available~73ab5ee9-830e-4b7f-9e99-195295bb5e34
