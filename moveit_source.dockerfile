ARG BASEIMAGE
FROM ${BASEIMAGE}

ARG DISTRO
ENV ROS_DISTRO ${DISTRO}

RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && bash install_moveit_source_packages.bash
