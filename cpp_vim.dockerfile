# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
FROM ${BASEIMAGE}
SHELL ["bash", "-c"]

RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && cp vimrc /etc/vim/ \
    && cp ctags /etc/vim/ \
    && cp gdbinit /etc/gdb/ \
    && cp printers.py /etc/gdb/
