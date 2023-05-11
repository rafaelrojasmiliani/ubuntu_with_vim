#!/bin/bash
main() {

    if [[ ! "${ROS_DISTRO}" =~ \
        ^(foxy|galactic|humble|kinetic|melodic|noetic)$ ]]; then
        echo "Error: Distro \"${ROS_DISTRO}\" does not exists"
        exit 1
    fi

    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get remove \
            -y -o Dpkg::Options::="--force-confnew" \
            $(dpkg -l | grep libomp | awk '{print $2}')
    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-${ROS_DISTRO}-moveit-*

    if [[ "${ROS_DISTRO}" =~ \
        ^(kinetic|melodic|noetic)$ ]]; then
        apt-get update &&
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends \
                -o Dpkg::Options::="--force-confnew" \
                ros-${ROS_DISTRO}-panda-moveit-config \
                ros-noetic-franka-gripper
    else
        apt-get update &&
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends \
                -o Dpkg::Options::="--force-confnew" \
                ros-${ROS_DISTRO}-moveit-resources-panda-moveit-config
    fi

}

main $@
