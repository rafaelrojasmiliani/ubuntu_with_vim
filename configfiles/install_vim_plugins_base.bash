#!/bin/bash
plugins=(
    https://github.com/VundleVim/Vundle.vim.git                      # package manager
    https://github.com/junegunn/vim-easy-align.git                   # aligning with :EasyAlign
    https://github.com/ycm-core/YouCompleteMe.git                    # autocompleter
    https://github.com/vim-latex/vim-latex.git                       # latex tools
    https://github.com/include-what-you-use/include-what-you-use.git # include what you use
    https://github.com/preservim/tagbar.git                          # tag bar
    https://github.com/jlanzarotta/bufexplorer.git                   # Change between buffers
    https://github.com/dense-analysis/ale.git                        # linter
    https://github.com/aklt/vim-substitute.git                       # substitute with ;;
    https://github.com/SirVer/ultisnips.git                          # snipets 1
    https://github.com/rafaelrojasmiliani/vim_snippets_ros.git       # snipets for ROS
    https://github.com/honza/vim-snippets.git                        # snipets database
    https://github.com/tpope/vim-fugitive.git                        # git
    https://github.com/sukima/xmledit.git                            # close xml tags
    https://github.com/puremourning/vimspector.git                   # debugger
    https://github.com/junegunn/fzf.git                              # fast search
    https://github.com/junegunn/fzf.vim.git                          # fast search
    https://github.com/preservim/nerdtree.git                        # file explorer
    https://github.com/Xuyuanp/nerdtree-git-plugin.git               # file explorer with git info
    https://github.com/lfv89/vim-interestingwords.git                # highlight words
    https://github.com/kkoomen/vim-doge.git                          # automatic documentation generation
    https://github.com/Glench/Vim-Jinja2-Syntax.git                  # Jinja syntax
    https://github.com/tpope/vim-dispatch.git                        # Async terminal, make qfix stuff
    https://github.com/ilyachur/cmake4vim.git                        # cmake tools
    https://github.com/Yggdroot/indentLine.git                       # indent lines
    https://github.com/tpope/vim-commentary.git                      # comment with gc in visual mode and gcc+count in normal mode
    https://github.com/tpope/vim-repeat.git                          # remaps .
    https://github.com/tpope/vim-surround.git                        # mappings to del, change and add surroundings in pairs.
    https://github.com/tpope/vim-unimpaired.git                      # ???
    https://github.com/svermeulen/vim-cutlass.git                    # overrides delete operations to avoind affecting the current yank.
    https://github.com/svermeulen/vim-yoink.git                      # maintain a history of yanks that you can choose between when pasting.
    https://github.com/mbbill/undotree.git                           # visualizes undo history
    https://github.com/airblade/vim-gitgutter                        # shows a git diff in the sign column.
    https://github.com/thinca/vim-editvar                            # edit a variable on the buffer
    https://github.com/powerline/powerline.git                       # fancy status line
    https://github.com/samoshkin/vim-find-files.git                  # find files with Find
    https://github.com/samoshkin/vim-mergetool.git
    https://github.com/kien/ctrlp.vim.git        # several stuff to find
    https://github.com/tacahiroy/ctrlp-funky.git # finds functions with CtrlPFunky
    https://github.com/liuchengxu/vim-clap.git   # seval stuff Clab (files|buffers|yanks|registers)
    https://github.com/liuchengxu/vista.vim      # vista
    https://github.com/stevearc/vim-arduino.git  # arduino interface
    https://github.com/sheerun/vim-polyglot.git
    https://github.com/tpope/vim-markdown.git
    https://github.com/ilyachur/gtest-vim
    https://github.com/kamykn/spelunker.vim.git
    https://github.com/blueyed/vim-diminactive.git
    https://github.com/rickhowe/spotdiff.vim.git     # A range and area selectable diffthis to compare partially
    https://github.com/rickhowe/diffchar.vim.git     # Highlight the exact differences, based on characters and words
    https://github.com/Yohannfra/Vim-Goto-Header.git # Switch between header and sourcefile. Also Go to header under the cursor.
    https://github.com/hahdookin/miniterm.vim.git
    https://github.com/rbong/vim-flog.git
)

main() {
    set -xeu
    for plugin in ${plugins[@]}; do
        git clone --recurse-submodules -j8 $plugin \
            /etc/vim/bundle/$(echo $(basename $plugin) | sed 's/\.git//')
    done
    DISTRIB_RELEASE=$(lsb_release -sr 2>/dev/null)

    # --------------  vimspector
    source /etc/lsb-release
    if [ $DISTRIB_RELEASE = "18.04" ]; then
        cd /etc/vim/bundle/vimspector &&
            python3 install_gadget.py \
                --enable-c --enable-cpp --sudo
        #rm -rf /etc/vim/bundle/YouCompleteMe && git clone https://github.com/ycm-core/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe
    else
        cd /etc/vim/bundle/vimspector &&
            python3 install_gadget.py \
                --enable-c --enable-cpp --enable-python --sudo
    fi

    # --------------  youcompleteme
    cd /etc/vim/bundle/YouCompleteMe
    if [ $DISTRIB_RELEASE != "24.04" ]; then
        git checkout legacy-vim-8.2
    fi
    git submodule update --init --recursive &&
        python3 install.py --java-completer --clangd-completer --force-sudo

    export YCMC=$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_c*.so')
    patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$YCMC"
    #chmod 777 /etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/tabnine

    # --------------  fzf
    cd /etc/vim/bundle/fzf && ./install --all

    # --------------  install maple with cargo and vim-clap
    source /root/.cargo/env
    cd /etc/vim/bundle/vim-clap && cargo build --release

    export NVM_DIR=/opt/nvm
    source /opt/nvm/nvm.sh
    # ---------- install ycm lsp
    cd /etc/vim
    git clone https://github.com/ycm-core/lsp-examples.git
    cd lsp-examples
    python3 ./install.py --enable-bash --enable-cmake --enable-docker

    # ---- remove unused stuff
    rm -rf $(find /etc/vim/bundle -type f \( -name "*.a" -o -name "*.o" \))

    rm -rf $(find /etc/vim/bundle -type d -name ".git")

}

main
