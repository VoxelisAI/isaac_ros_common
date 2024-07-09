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

# Restart udev daemon
service udev restart

if [ "$1" = "NONE" ]; then
    $@
fi

# $@

# Check if current directory is /workspaces/isaac_ros-dev
if [[ "$(pwd)" != *"/workspaces/isaac_ros-dev"* ]]; then
    echo "Error: Not in /workspaces/isaac_ros-dev directory. Please navigate to /workspaces/isaac_ros-dev before running this script."
    exit 1
fi

export LD_LIBRARY_PATH=/workspaces/isaac_ros-dev/install/isaac_ros_gxf/share/isaac_ros_gxf/gxf/lib/multimedia:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/workspaces/isaac_ros-dev/install/isaac_ros_gxf/share/isaac_ros_gxf/gxf/lib/:$LD_LIBRARY_PATH

export DISPLAY=:0

exec tail -f /dev/null
$@
