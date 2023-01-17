

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
                    ros-$distro-gazebo-ros \
                    ros-$distro-gazebo-ros-control \
                    ros-$distro-ifopt \
                    ros-$distro-joint-state-controller \
                    ros-$distro-joint-state-publisher \
                    ros-$distro-joint-trajectory-action \
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
                    ros-$distro-rqt-publisher\
                    ros-$distro-rqt-py-common \
                    ros-$distro-rqt-service-caller \
                    ros-$distro-rqt-tf-tree \
                    ros-$distro-smach \
                    ros-$distro-velocity-controllers \
                    ros-$distro-xacro
    if ! dpkg --verify ros-$distro-moveit-ros 2>/dev/null; then
        apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            ros-$distro-moveit-resources-fanuc-description \
            ros-$distro-moveit-resources-fanuc-moveit-config \
            ros-$distro-moveit-resources-panda-description \
            ros-$distro-moveit-resources-panda-moveit-config \
            ros-$distro-moveit-resources-panda-moveit-config \
            ros-$distro-moveit-resources-pr2-description \
            ros-$distro-moveit-resources-prbt-moveit-config \
            ros-$distro-moveit-resources-prbt-pg70-support \
            ros-$distro-moveit-resources-prbt-support \
            ros-$distro-panda-moveit-config
    fi
}


main $@
