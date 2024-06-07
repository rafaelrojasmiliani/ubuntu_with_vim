#!/bin/bash
main() {

    set -xe

    if [[ ! "${ROS_DISTRO}" =~ \
        ^(foxy|galactic|humble|kinetic|melodic|noetic|jazzy)$ ]]; then
        echo "Error: Distro \"${ROS_DISTRO}\" does not exists"
        exit 1
    fi

    if [[ "${ROS_DISTRO}" =~ \
        ^(kinetic|melodic|noetic)$ ]]; then

        ## Remove ifopt only in ros1
        rm -rf /usr/share/ifopt/
        rm -f /usr/lib/x86_64-linux-gnu/libifopt_core.so
        rm -fr /usr/include/ifopt
        rm -rf /usr/lib/x86_64-linux-gnu/ifopt/
        rm -rf /usr/lib/x86_64-linux-gnu/libifopt_ipopt.so
        echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" \
            >/etc/apt/sources.list.d/ros1-latest.list
        curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
        apt-get update

        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            python3-rosdep

    else

        curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $(lsb_release -cs)) main" | sudo tee /etc/apt/sources.list.d/ros2.list >/dev/null

        if [ $ROS_DISTRO = "jazzy" ]; then
            apt-get update
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                python3-rosdep
        else
            apt-get update
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                python3-rosdep2
        fi

    fi

    # Universal packages, valid for ROS 1 and 2
    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-${ROS_DISTRO}-control-msgs \
            ros-${ROS_DISTRO}-effort-controllers \
            ros-${ROS_DISTRO}-eigen-stl-containers \
            ros-${ROS_DISTRO}-eigenpy \
            ros-${ROS_DISTRO}-geometric-shapes \
            ros-${ROS_DISTRO}-joint-state-publisher \
            ros-${ROS_DISTRO}-joint-trajectory-controller \
            ros-${ROS_DISTRO}-moveit-msgs \
            ros-${ROS_DISTRO}-ompl \
            ros-${ROS_DISTRO}-pcl-ros \
            ros-${ROS_DISTRO}-plotjuggler \
            ros-${ROS_DISTRO}-plotjuggler-ros \
            ros-${ROS_DISTRO}-position-controllers \
            ros-${ROS_DISTRO}-robot-state-publisher \
            ros-${ROS_DISTRO}-ros-base \
            ros-${ROS_DISTRO}-rqt \
            ros-${ROS_DISTRO}-ruckig \
            ros-${ROS_DISTRO}-smach \
            ros-${ROS_DISTRO}-srdfdom \
            ros-${ROS_DISTRO}-velocity-controllers \
            ros-${ROS_DISTRO}-xacro

    # Universal packages until ros jazzy
    if [ $ROS_DISTRO = "jazzy" ]; then
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-${ROS_DISTRO}-ros-gz \
            ros-${ROS_DISTRO}-gz-ros2-control \
            robotpkg-ros-lint
    else
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-${ROS_DISTRO}-gazebo-ros
    fi

    if [[ "${ROS_DISTRO}" =~ \
        ^(kinetic|melodic|noetic)$ ]]; then

        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-${ROS_DISTRO}-gazebo-ros-control \
            ros-${ROS_DISTRO}-ifopt \
            ros-${ROS_DISTRO}-joint-state-controller \
            ros-${ROS_DISTRO}-joint-trajectory-action \
            ros-${ROS_DISTRO}-jsk-rqt-plugins \
            ros-${ROS_DISTRO}-jsk-rviz-plugins \
            ros-${ROS_DISTRO}-pybind11-catkin \
            ros-${ROS_DISTRO}-roslint \
            ros-${ROS_DISTRO}-rosparam-shortcuts \
            ros-${ROS_DISTRO}-warehouse-ros \
            ros-${ROS_DISTRO}-warehouse-ros-mongo \
            ros-${ROS_DISTRO}-warehouse-ros-sqlite

        if [ "${ROS_DISTRO}" = "noetic" ]; then
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                python3-catkin-* \
                ros-${ROS_DISTRO}-rqt-* \
                ros-noetic-hpp-fcl
            cd / && mkdir -p ws/src && cd ws/src &&
                git clone https://github.com/tork-a/rqt_joint_trajectory_plot.git &&
                cd .. && source /opt/ros/noetic/setup.bash &&
                catkin config --install -DCMAKE_BUILD_TYPE=Release -DCATKIN_SKIP_TESTING=ON --install-space /opt/ros/noetic &&
                catkin build && cd / && rm -rf /ws
        fi
    else

        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-${ROS_DISTRO}-rviz-2d-overlay-msgs \
            ros-${ROS_DISTRO}-rviz-2d-overlay-plugins \
            ros-${ROS_DISTRO}-ament-* \
            ros-${ROS_DISTRO}-joint-state-broadcaster \
            ros-${ROS_DISTRO}-rviz-2d-overlay-msgs \
            ros-${ROS_DISTRO}-rviz-2d-overlay-plugins \
            python3-colcon-core \
            python3-colcon-ros \
            python3-colcon-common-extensions \
            python3-colcon-hardware-acceleration

    fi

    # Force loading of the ros packages
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >>/etc/bash.bashrc
}

main $@
