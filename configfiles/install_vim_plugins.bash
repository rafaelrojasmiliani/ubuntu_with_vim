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
    https://github.com/github/copilot.vim.git
)
# Check Vim version
vim_version=$(vim --version | awk 'NR==1 {print $5}')
if awk -v v="$vim_version" 'BEGIN {exit !(v >= 9.1)}'; then
    plugins+=("https://github.com/ggml-org/llama.vim.git")
fi

main() {
    set -xeu
    DISTRIB_RELEASE=$(lsb_release -sr 2>/dev/null)
    for plugin in ${plugins[@]}; do
        git clone --recurse-submodules -j$(nproc) $plugin \
            /etc/vim/bundle/$(echo $(basename $plugin) | sed 's/\.git//')
    done

    # --------------  install doge
    vim -c ':call doge#install()' -c 'sleep 300' -c 'qa!'
    sudo chmod 777 /etc/vim/
    sudo chmod 777 /etc/vim/vimrc
    sudo chmod 777 /etc/vim/bundle/

}

main
