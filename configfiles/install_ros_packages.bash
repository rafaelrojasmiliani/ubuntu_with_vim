

main(){
    distro=$1
    if [[ ! "$distro" =~ ^(kinetic|melodic|noetic)$ ]]; then
        exit 1
    fi

    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    python3-catkin-tools \
                    ros-$distro-control-msgs \
                    ros-$distro-velocity-controllers \
                    ros-$distro-joint-trajectory-action \
                    ros-$distro-ifopt \
                    ros-$distro-plotjuggler \
                    ros-$distro-joint-trajectory-controller \
                    ros-$distro-joint-trajectory-action \
                    ros-$distro-xacro \
                    ros-$distro-gazebo-ros \
                    ros-$distro-gazebo-ros-control \
                    ros-$distro-joint-state-controller \
                    ros-$distro-position-controllers \
                    ros-$distro-robot-state-publisher \
                    ros-$distro-joint-state-publisher \
                    ros-$distro-rqt \
                    ros-$distro-rqt-graph \
                    ros-$distro-roslint \
                    ros-$distro-plotjuggler-ros \
                    ros-$distro-rqt-gui \
                    ros-$distro-rqt-gui-py \
                    ros-$distro-rqt-py-common \
                    ros-$distro-moveit-msgs \
                    ros-$distro-rqt-joint-trajectory-controller \
                    ros-$distro-jsk-rviz-plugins

}


main $@
