################################################################################
#                                                                              #
# Copyright (C) 2020 Fondazione Istitito Italiano di Tecnologia (IIT)          #
# All Rights Reserved.                                                         #
#                                                                              #
################################################################################

# @author Nicolò Genesio <nicolo.genesio@iit.it>


project(setup-gazebo-bp
        VERSION 0.0.1)

find_package(YCM REQUIRED)


add_subdirectory(models)

include(AddUninstallTarget)