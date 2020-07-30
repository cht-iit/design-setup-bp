################################################################################
#                                                                              #
# Copyright (C) 2020 Fondazione Istitito Italiano di Tecnologia (IIT)          #
# All Rights Reserved.                                                         #
#                                                                              #
################################################################################

# Install the application
file(GLOB apps ${CMAKE_CURRENT_SOURCE_DIR}/*.xml)
yarp_install(FILES ${apps} DESTINATION ${ICUBCONTRIB_APPLICATIONS_INSTALL_DIR})

# Install startup scripts
file(GLOB scripts ${CMAKE_CURRENT_SOURCE_DIR}/*.sh)
install(PROGRAMS ${scripts} DESTINATION bin)