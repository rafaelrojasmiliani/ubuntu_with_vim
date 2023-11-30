#!/bin/bash
plugins=(
    https://github.com/rhysd/git-messenger.vim.git
)

main() {
    set -x
    for plugin in ${plugins[@]}; do
        git clone --recurse-submodules -j8 $plugin \
            /etc/vim/bundle/$(echo $(basename $plugin) | sed 's/\.git//')
    done

}

main
