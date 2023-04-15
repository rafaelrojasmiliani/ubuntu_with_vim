#!/bin/bash
plugins=(
    https://github.com/VundleVim/Vundle.vim.git    # package manager
    https://github.com/ycm-core/YouCompleteMe.git  # autocompleter
    https://github.com/puremourning/vimspector.git # debugger
    https://github.com/junegunn/fzf.git            # fast search
    https://github.com/junegunn/fzf.vim.git        # fast search
    https://github.com/kkoomen/vim-doge.git        # automatic documentation generation
    https://github.com/liuchengxu/vim-clap.git     # seval stuff Clab (files|buffers|yanks|registers)
)

main() {
    set -x
    for plugin in ${plugins[@]}; do
        git clone $plugin \
            /etc/vim/bundle/$(echo $(basename $plugin) | sed 's/\.git//')
    done

    # --------------  vimspector
    source /etc/lsb-release
    if [ $DISTRIB_RELEASE = "18.04" ]; then
        cd /etc/vim/bundle/vimspector &&
            python3 install_gadget.py --enable-c --enable-cpp --sudo
        #rm -rf /etc/vim/bundle/YouCompleteMe && git clone https://github.com/ycm-core/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe
    else
        cd /etc/vim/bundle/vimspector &&
            python3 install_gadget.py \
                --enable-c --enable-cpp --enable-python --sudo
    fi

    # --------------  youcompleteme
    cd /etc/vim/bundle/YouCompleteMe &&
        git submodule update --init --recursive &&
        python3 install.py --clang-completer --clangd-completer --force-sudo

    export YCMC=$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_c*.so')
    patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$YCMC"
    #chmod 777 /etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/tabnine

    # --------------  fzf
    cd /etc/vim/bundle/fzf && ./install --all

    # --------------  install maple with cargo and vim-clap
    source /root/.cargo/env
    cd /etc/vim/bundle/vim-clap && cargo build --release

    # --------------  install doge
    echo -ne '\n' | vim -c ':call doge#install()' -c ':q'

}

main
