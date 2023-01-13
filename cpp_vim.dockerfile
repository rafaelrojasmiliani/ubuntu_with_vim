# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
FROM ${BASEIMAGE}

ARG ROSDISTRO

RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && source common.bash \
    && bash install_ubuntu_base.bash \
    && bash install_vim_plugins.bash \
    && [ ! -z ${ROSDISTRO} ] &&  bash install_ros_packages.bash ${ROSDISTRO} || true \
    && [ ! -z ${ROSDISTRO} ] && if is_ros2 ${ROSDISTRO}; then cp ycm_extra_conf_ros2.py /etc/vim/ycm_extra_conf.py; else cp ycm_extra_conf_ros.py /etc/vim/ycm_extra_conf.py fi; || cp ycm_extra_conf.py /etc/vim/ \
    && cp vimrc /etc/vim/ \
    && cp ctags /etc/vim/ \
    && cp gdbinit /etc/gdb/ \
    && cp printers.py /etc/gdb/
