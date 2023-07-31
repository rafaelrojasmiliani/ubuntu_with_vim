#!/bin/bash
main() {

    set -x

    ## Remove ifopt
    rm -rf /usr/share/ifopt/
    rm -f /usr/lib/x86_64-linux-gnu/libifopt_core.so
    rm -fr /usr/include/ifopt
    rm -rf /usr/lib/x86_64-linux-gnu/ifopt/
    rm -rf /usr/lib/x86_64-linux-gnu/libifopt_ipopt.so

    if [[ ! "${ROS_DISTRO}" =~ \
        ^(foxy|galactic|humble|kinetic|melodic|noetic)$ ]]; then
        echo "Error: Distro \"${ROS_DISTRO}\" does not exists"
        exit 1
    fi
    if [[ "${ROS_DISTRO}" =~ \
        ^(kinetic|melodic|noetic)$ ]]; then
        echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" \
            >/etc/apt/sources.list.d/ros1-latest.list
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            python3-rosdep2
    else

        curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $(lsb_release -cs)) main" | sudo tee /etc/apt/sources.list.d/ros2.list >/dev/null
        apt-get update

        if [ "${ROS_DISTRO}" = "noetic" ]; then
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                python3-rosdep
        else
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                python-rosdep
        fi

    fi

    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            python3-catkin \
            python3-catkin-tools \
            ros-${ROS_DISTRO}-control-msgs \
            ros-${ROS_DISTRO}-gazebo-ros \
            ros-${ROS_DISTRO}-gazebo-ros-control \
            ros-${ROS_DISTRO}-ifopt \
            ros-${ROS_DISTRO}-joint-state-controller \
            ros-${ROS_DISTRO}-joint-state-publisher \
            ros-${ROS_DISTRO}-joint-trajectory-action \
            ros-${ROS_DISTRO}-joint-trajectory-controller \
            ros-${ROS_DISTRO}-jsk-rqt-plugins \
            ros-${ROS_DISTRO}-jsk-rviz-plugins \
            ros-${ROS_DISTRO}-moveit-msgs \
            ros-${ROS_DISTRO}-pcl-ros \
            ros-${ROS_DISTRO}-plotjuggler \
            ros-${ROS_DISTRO}-plotjuggler-ros \
            ros-${ROS_DISTRO}-position-controllers \
            ros-${ROS_DISTRO}-robot-state-publisher \
            ros-${ROS_DISTRO}-ros-base \
            ros-${ROS_DISTRO}-roslint \
            ros-${ROS_DISTRO}-rqt \
            ros-${ROS_DISTRO}-rqt-action \
            ros-${ROS_DISTRO}-rqt-bag \
            ros-${ROS_DISTRO}-rqt-console \
            ros-${ROS_DISTRO}-rqt-controller-manager \
            ros-${ROS_DISTRO}-rqt-dep \
            ros-${ROS_DISTRO}-rqt-graph \
            ros-${ROS_DISTRO}-rqt-gui \
            ros-${ROS_DISTRO}-rqt-gui-cpp \
            ros-${ROS_DISTRO}-rqt-gui-py \
            ros-${ROS_DISTRO}-rqt-image-view \
            ros-${ROS_DISTRO}-rqt-joint-trajectory-controller \
            ros-${ROS_DISTRO}-rqt-launch \
            ros-${ROS_DISTRO}-rqt-logger-level \
            ros-${ROS_DISTRO}-rqt-moveit \
            ros-${ROS_DISTRO}-rqt-publisher \
            ros-${ROS_DISTRO}-rqt-py-common \
            ros-${ROS_DISTRO}-rqt-reconfigure \
            ros-${ROS_DISTRO}-rqt-robot-monitor \
            ros-${ROS_DISTRO}-rqt-rosmon \
            ros-${ROS_DISTRO}-rqt-runtime-monitor \
            ros-${ROS_DISTRO}-rqt-rviz \
            ros-${ROS_DISTRO}-rqt-service-caller \
            ros-${ROS_DISTRO}-rqt-shell \
            ros-${ROS_DISTRO}-rqt-tf-tree \
            ros-${ROS_DISTRO}-rqt-top \
            ros-${ROS_DISTRO}-rqt-web \
            ros-${ROS_DISTRO}-ruckig \
            ros-${ROS_DISTRO}-smach \
            ros-${ROS_DISTRO}-velocity-controllers \
            ros-${ROS_DISTRO}-xacro

    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >>/etc/bash.bashrc
}

main $@
