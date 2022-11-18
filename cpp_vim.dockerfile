# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
ARG ROSDISTRO
FROM ${BASEIMAGE}

RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && bash install_ubuntu_base.bash \
    && bash install_vim_plugins.bash \
    && if [ ! -z ${ROSDISTRO} ]; then bash install_ros_packages.bash ${ROSDISTRO}; fi \
    && cp vimrc /etc/vim/ \
    && cp ycm_extra_conf.py /etc/vim/ \
    && cp ctags /etc/vim/ \
    && cp gdbinit /etc/gdb/ \
    && cp printers.py /etc/gdb/
