
FROM ubuntu:18.04

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
