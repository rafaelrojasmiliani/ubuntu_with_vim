#!/bin/bash
main() {
    set -xeu

    # Remove last omp
    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get remove \
            -y -o Dpkg::Options::="--force-confnew" \
            $(dpkg -l | grep libomp | awk '{print $2}')
    DEBIAN_FRONTEND=noninteractive apt-get install
    -y -o Dpkg::Options::="--force-confnew" \
        ros-${ROS_DISTRO}-moveit-ros-warehouse \
        ros-${ROS_DISTRO}-moveit-resources

    if [[ ! "${ROS_DISTRO}" =~ \
        ^(foxy|galactic|humble|kinetic|melodic|noetic)$ ]]; then
        echo "Error: Distro \"${ROS_DISTRO}\" does not exists"
        exit 1
    fi
    if [[ "${ROS_DISTRO}" =~ \
        ^(kinetic|melodic|noetic)$ ]]; then
        git clone --depth=1 --branch=${ROS_DISTRO}-devel https://github.com/ros-planning/moveit.git /ros_ws/src/moveit
        cd /ros_ws
        rosdep init && rosdep update && DEBIAN_FRONTEND=noninteractive rosdep install -r -q --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y
        cd /
        rm -rf /ros_ws
    else
        git clone --depth=1 --branch=${ROS_DISTRO}-devel https://github.com/ros-planning/moveit2.git /ros_ws/src/moveit2
        cd /ros_ws
        rosdep2 init && rosdep2 update && DEBIAN_FRONTEND=noninteractive rosdep2 install -r -q --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y
        cd /
        rm -rf /ros_ws
    fi

}

main $@
