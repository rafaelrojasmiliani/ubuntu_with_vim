

main(){
    set -x
    distro=$1
    if [[ ! "$distro" =~ ^(foxy|galactic|humble|kinetic|melodic|noetic)$ ]]; then
        echo "Error: Distro $distro does not exists"
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
                    ros-$distro-jsk-rviz-plugins \
                    ros-$distro-pcl-ros
    if ! dpkg --verify ros-$distro-moveit-ros 2>/dev/null; then
        apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-$distro-moveit-resources-fanuc-moveit-config \
            ros-$distro-moveit-resources-fanuc-description \
            ros-$distro-moveit-resources-panda-description \
            ros-$distro-moveit-resources-panda-moveit-config \
            ros-$distro-moveit-resources-pr2-description \
            ros-$distro-moveit-resources-prbt-moveit-config \
            ros-$distro-moveit-resources-prbt-support \
            ros-$distro-moveit-resources-prbt-pg70-support
    fi
}


main $@
