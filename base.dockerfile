# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
FROM ${BASEIMAGE}
SHELL ["bash", "-c"]

RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && bash install_ubuntu_base.bash \
    && bash install_vim_plugins_base.bash \
    && echo "kernel.yama.ptrace_scope = 0" >> /etc/sysctl.conf \
    && sysctl --system

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
