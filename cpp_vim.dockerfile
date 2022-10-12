# This file tells docker what image must be created
# in order to be ahble to test this library
FROM ubuntu:22.04

RUN --mount=type=bind,source=./,target=/workspace,rw \
    cd / \
    && cd /workspace/configfiles \
    && bash install_ubuntu_base.bash \
    && bash install_vim_plugins.bash \
    && cp vimrc /etc/vim/ \
    && cp ycm_extra_conf.py /etc/vim/ \
    && cp ctags /etc/vim/ \
    && cp gdbinit /etc/gdb/ \
    && cp printers.py /etc/gdb/
