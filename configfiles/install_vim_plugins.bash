#!/bin/bash
plugins=(
    https://github.com/rhysd/git-messenger.vim.git
    https://github.com/tommcdo/vim-fubitive.git
    https://github.com/tpope/vim-rhubarb.git
    https://github.com/shumphrey/fugitive-gitlab.vim.git
    https://github.com/udalov/kotlin-vim.git
    https://github.com/jpalardy/vim-slime.git
    https://github.com/ludovicchabant/vim-gutentags.git
    https://github.com/skywind3000/gutentags_plus.git
)

main() {
    set -xeu
    DISTRIB_RELEASE=$(lsb_release -sr 2>/dev/null)
    for plugin in ${plugins[@]}; do
        git clone --recurse-submodules -j8 $plugin \
            /etc/vim/bundle/$(echo $(basename $plugin) | sed 's/\.git//')
    done

    # --------------  install doge
    vim -c ':call doge#install()' -c 'sleep 300' -c 'qa!'
    sudo chmod -R 777 /etc/vim/
    sudo chmod -R 777 /etc/vim/vimrc

}

main
