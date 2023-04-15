# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
FROM ${BASEIMAGE}
SHELL ["bash", "-c"]

ARG ROSDISTRO

RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && source common.bash \
    && bash install_ubuntu_base.bash \
    && bash install_vim_plugins_base.bash
