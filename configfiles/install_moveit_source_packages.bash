#!/bin/bash
main() {
    set -x

    if [[ ! "${ROS_DISTRO}" =~ \
        ^(foxy|galactic|humble|kinetic|melodic|noetic)$ ]]; then
        echo "Error: Distro \"${ROS_DISTRO}\" does not exists"
        exit 1
    fi
    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get remove \
            -y -o Dpkg::Options::="--force-confnew" \
            $(dpkg -l | grep libomp | awk '{print $2}')

    git clone --depth=1 --branch=${ROS_DISTRO}-devel https://github.com/ros-planning/moveit.git /ros_ws/src
    cd /ros_ws
    rosdep init && rosdep update && rosdep install -r -q --from-paths src --ignore-src --rosdistro noetic -y

}

main $@
