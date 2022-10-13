plugins=(
https://github.com/VundleVim/Vundle.vim.git                      # package manager
https://github.com/junegunn/vim-easy-align.git                   # aligning tool
https://github.com/tabnine/YouCompleteMe.git                     # autocompleter
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
https://github.com/SantinoKeupp/lualine-cmake4vim.nvim.git       # more cmake tools
)

main(){
    for plugin in ${plugins[@]}; do
        git clone $plugin /etc/vim/bundle/$(echo $(basename $plugin) | sed 's/\.git//')
    done

    source /etc/lsb-release
    if [ $DISTRIB_RELEASE = "18.04" ]; then
        cd /etc/vim/bundle/vimspector &&  python3 install_gadget.py --enable-c --enable-cpp  --sudo
        #rm -rf /etc/vim/bundle/YouCompleteMe && git clone https://github.com/ycm-core/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe
    else
        cd /etc/vim/bundle/vimspector &&  python3 install_gadget.py --enable-c --enable-cpp --enable-python --sudo
    fi

    cd /etc/vim/bundle/YouCompleteMe &&  git submodule update --init --recursive && python3 install.py --clang-completer --clangd-completer --force-sudo
    export YCM_CORE=$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_core*.so')
    patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$YCM_CORE"
    chmod 777 /etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/tabnine

}

main
