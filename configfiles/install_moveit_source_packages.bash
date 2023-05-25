#!/bin/bash
main() {
    set -x

    # Remove last omp
    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get remove \
            -y -o Dpkg::Options::="--force-confnew" \
            $(dpkg -l | grep libomp | awk '{print $2}')

    if [[ ! "${ROS_DISTRO}" =~ \
        ^(foxy|galactic|humble|kinetic|melodic|noetic)$ ]]; then
        echo "Error: Distro \"${ROS_DISTRO}\" does not exists"
        exit 1
    fi
    if [[ "${ROS_DISTRO}" =~ \
        ^(kinetic|melodic|noetic)$ ]]; then
        git clone --depth=1 --branch=${ROS_DISTRO}-devel https://github.com/ros-planning/moveit.git /ros_ws/src/moveit
    else
        git clone --depth=1 --branch=${ROS_DISTRO}-devel https://github.com/ros-planning/moveit2.git /ros_ws/src/moveit2

    fi

    cd /ros_ws
    rosdep init && rosdep update && DEBIAN_FRONTEND=noninteractive rosdep install -r -q --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y

}

main $@
