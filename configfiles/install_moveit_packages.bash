#!/bin/bash
main() {

    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-${ROS_DISTRO}-moveit-* \
            ros-${ROS_DISTRO}-panda-moveit-config \
            ros-${ROS_DISTRO}-panda-moveit-config

}

main $@
