# Copyright (C) 2020 Fondazione Istituto Italiano di Tecnologia (IIT) All Rights Reserved.

macro(SUBDIRLIST result curdir)
  file(GLOB children RELATIVE ${curdir} ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${curdir}/${child})
      list(APPEND dirlist ${child})
    endif()
  endforeach()
  set(${result} ${dirlist})
endmacro()

# Copy the setup-gazebo-bp folder in the build tree
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/setup-gazebo-bp DESTINATION ${CMAKE_BINARY_DIR})

# List all the .sdf files in  ${CMAKE_BINARY_DIR}/setup-gazebo-bp
file(GLOB_RECURSE sdf_files ${CMAKE_BINARY_DIR}/*.sdf)

# Workaround for the following osrf/gazebo issues:
# * https://github.com/osrf/gazebo/issues/2728
# * https://github.com/osrf/gazebo/issues/2739
# The goal is support Gazebo 11 while keeping compatibility with Gazebo 9 and 10
# If we drop support for Gazebo 9 and 10, we can just directly change all the SDF files to 1.7
if(GAZEBO_VERSION VERSION_GREATER_EQUAL 11.0)
  message(STATUS "Gazebo >= 11 detected, patching SDF models to version 1.7")
  foreach(sdf_file IN LISTS sdf_files)
    file(READ ${sdf_file} SDF_CONTENT)
    string(REPLACE "<sdf version='1.5'>" "<sdf version='1.7'>" SDF_CONTENT_CONVERT_TO_1_7 ${SDF_CONTENT})
    file(WRITE ${sdf_file} ${SDF_CONTENT_CONVERT_TO_1_7})
  endforeach()
endif()

# Install the whole models directory
install(DIRECTORY ${CMAKE_BINARY_DIR}/setup-gazebo-bp DESTINATION share)

# Install the whole gazebo/worls
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/gazebo/worlds DESTINATION share/gazebo)
