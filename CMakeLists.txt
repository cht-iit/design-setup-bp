################################################################################
#                                                                              #
# Copyright (C) 2020 Fondazione Istitito Italiano di Tecnologia (IIT)          #
# All Rights Reserved.                                                         #
#                                                                              #
################################################################################

# @author Nicolò Genesio <nicolo.genesio@iit.it>

cmake_minimum_required(VERSION 3.5)
project(design-setup-bp
        VERSION 0.0.1)

find_package(YCM REQUIRED)
find_package(ICUBcontrib REQUIRED)
list(APPEND CMAKE_MODULE_PATH ${ICUBCONTRIB_MODULE_PATH})
include(ICUBcontribOptions)
include(ICUBcontribHelpers)

icubcontrib_set_default_prefix()

add_subdirectory(scripts)
add_subdirectory(models)
add_subdirectory(are-bp)

include(AddUninstallTarget)
