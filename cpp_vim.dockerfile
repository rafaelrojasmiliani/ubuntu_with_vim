# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
FROM ${BASEIMAGE}
SHELL ["bash", "-c"]
ARG YCM_FILE


RUN --mount=type=bind,source=./,target=/workspace,rw \
    set -x && cd /workspace/configfiles \
    && cp vimrc /etc/vim/ \
    && cp bashrc /etc/bash.bashrc \
    && { [[ -f /etc/vim/lsp-examples/vimrc.generated ]] && cat /etc/vim/lsp-examples/vimrc.generated >> /etc/vim/vimrc; } || true  \
    && bash install_vim_plugins.bash \
    && cp ctags /etc/vim/ \
    && cp cmake_kits.cmake /etc/vim/ \
    && cp ${YCM_FILE} /etc/vim/ycm_extra_conf.py \
    && { [[ -d /etc/gdb ]] && cp gdbinit /etc/gdb/ && cp printers.py /etc/gdb/; } || true  \
    && mkdir -p /etc/vim/after/plugin/ \
    && cp after.vim /etc/vim/after/plugin/
