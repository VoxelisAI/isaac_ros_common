#!/bin/bash
#
# Copyright (c) 2021, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

# Build ROS dependency
echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
source /opt/ros/${ROS_DISTRO}/setup.bash

sudo apt-get update
rosdep update
rosdep install --from-paths /workspaces/isaac_ros-dev/src --ignore-src -r -y

# Restart udev daemon
sudo service udev restart

# $@

cd /workspaces/isaac_ros-dev
source install/setup.bash
cd /workspaces/isaac_ros-dev/src
git clone https://github.com/NVIDIA-ISAAC-ROS/gxf
git clone https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_nitros

# cd /workspaces/isaac_ros-dev/src/gxf && \
#   ./build_install_gxf_release.sh -i /workspaces/isaac_ros-dev/src/isaac_ros_nitros/isaac_ros_gxf

# # leopard camera pipeline
# cd /workspaces/isaac_ros-dev/src/isaac_ros_common
# git pull

# cd /workspaces/isaac_ros-dev/src/r2_libargus_sync_camera
# git switch origin/nitros_adapation
# git pull

cd /workspaces/isaac_ros-dev

# Check if current directory is /workspaces/isaac_ros-dev
if [[ "$(pwd)" != *"/workspaces/isaac_ros-dev"* ]]; then
    echo "Error: Not in /workspaces/isaac_ros-dev directory. Please navigate to /workspaces/isaac_ros-dev before running this script."
    exit 1
fi

source /opt/ros/humble/setup.bash
source install/setup.bash

colcon build
# colcon build --packages-select libargus_sync_camera
source install/setup.bash


export LD_LIBRARY_PATH=/workspaces/isaac_ros-dev/install/isaac_ros_gxf/share/isaac_ros_gxf/gxf/lib/multimedia:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/workspaces/isaac_ros-dev/install/isaac_ros_gxf/share/isaac_ros_gxf/gxf/lib/:$LD_LIBRARY_PATH


ros2 launch libargus_sync_camera libargus_sync_camera.launch.py

$@