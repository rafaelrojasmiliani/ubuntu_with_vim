#!/bin/bash
main() {

    set -x

    ## Remove ifopt
    rm -rf /usr/share/ifopt/
    rm -f /usr/lib/x86_64-linux-gnu/libifopt_core.so
    rm -fr /usr/include/ifopt
    rm -rf /usr/lib/x86_64-linux-gnu/ifopt/
    rm -rf /usr/lib/x86_64-linux-gnu/libifopt_ipopt.so

    distro=$1
    if [[ ! "$distro" =~ \
        ^(foxy|galactic|humble|kinetic|melodic|noetic)$ ]]; then
        echo "Error: Distro $distro does not exists"
        exit 1
    fi

    if [[ "$distro" = "melodic" ]]; then
        echo "deb http://packages.ros.org/ros/ubuntu bionic main" \
            >/etc/apt/sources.list.d/ros1-latest.list
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-melodic-ros-core=1.4.1-0*
    elif [[ "$distro" = "noetic" ]]; then
        echo "deb http://packages.ros.org/ros/ubuntu bionic main" \
            >/etc/apt/sources.list.d/ros1-latest.list
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-noetic-ros-core=1.5.0-1*
    elif [[ "$distro" = "foxy" ]]; then
        apt update && sudo apt install curl -y
        curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list >/dev/null
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-foxy-ros-base
    elif [[ "$distro" = "humble" ]]; then
        apt update && sudo apt install curl -y
        curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list >/dev/null
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-humble-ros-base
    fi

    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            python3-catkin-tools \
            ros-$distro-control-msgs \
            ros-$distro-gazebo-ros \
            ros-$distro-gazebo-ros-control \
            ros-$distro-ifopt \
            ros-$distro-joint-state-controller \
            ros-$distro-joint-state-publisher \
            ros-$distro-joint-trajectory-action \
            ros-$distro-joint-trajectory-controller \
            ros-$distro-jsk-rviz-plugins \
            ros-$distro-moveit-msgs \
            ros-$distro-pcl-ros \
            ros-$distro-plotjuggler \
            ros-$distro-plotjuggler-ros \
            ros-$distro-position-controllers \
            ros-$distro-robot-state-publisher \
            ros-$distro-roslint \
            ros-$distro-rqt \
            ros-$distro-rqt-graph \
            ros-$distro-rqt-gui \
            ros-$distro-rqt-gui-py \
            ros-$distro-rqt-joint-trajectory-controller \
            ros-$distro-rqt-publisher ros-$distro-rqt-py-common \
            ros-$distro-rqt-service-caller \
            ros-$distro-rqt-tf-tree \
            ros-$distro-smach \
            ros-$distro-velocity-controllers \
            ros-$distro-xacro \
            ros-$distro-rqt-logger-level

    if dpkg --verify ros-$distro-moveit-ros 2>/dev/null; then
        echo "----- Installing moveit extra packages"
        apt-get update &&
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends \
                -o Dpkg::Options::="--force-confnew" \
                ros-$distro-moveit-resources-fanuc-description \
                ros-$distro-moveit-resources-fanuc-moveit-config \
                ros-$distro-moveit-resources-panda-description \
                ros-$distro-moveit-resources-panda-moveit-config \
                ros-$distro-moveit-resources-panda-moveit-config \
                ros-$distro-moveit-resources-pr2-description \
                ros-$distro-moveit-resources-prbt-moveit-config \
                ros-$distro-moveit-resources-prbt-pg70-support \
                ros-$distro-moveit-resources-prbt-support \
                ros-$distro-panda-moveit-config \
                ros-$distro-franka-gripper
    else
        echo "----- Moveit Extra package will to be installed"
    fi
}

main $@
