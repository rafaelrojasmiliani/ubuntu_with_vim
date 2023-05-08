ARG BASEIMAGE
FROM ${BASEIMAGE}

ENV ROS_DISTRO ${DISTRO}

RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && bash install_ros_packages.bash
