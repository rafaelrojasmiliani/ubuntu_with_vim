FROM pandoc/latex:latest-ubuntu

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    python3-pip git iputils-ping net-tools netcat screen less \
                    python3-sympy \
                    exuberant-ctags \
                    cmake \
                    wget jsonlint libxml2-utils patchelf \
                    vim vim-gtk texlive-pictures gnuplot chktex exuberant-ctags \
                    && apt-get clean

RUN pip3 install cmakelang autopep8 pylint flake8 yamllint yamlfix yamlfmt

RUN chmod 777 /etc/vim
RUN mkdir -p /etc/vim/bundle
RUN chmod 777 /etc/vim/bundle

RUN git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim
RUN git clone https://github.com/vim-latex/vim-latex.git /etc/vim/bundle/vim-latex
RUN git clone https://github.com/preservim/tagbar.git /etc/vim/bundle/tagbar
RUN git clone https://github.com/jlanzarotta/bufexplorer.git /etc/vim/bundle/bufexplorer
RUN git clone https://github.com/dense-analysis/ale.git /etc/vim/bundle/ale
RUN git clone https://github.com/aklt/vim-substitute.git /etc/vim/bundle/vim-substitute
RUN git clone https://github.com/SirVer/ultisnips.git /etc/vim/bundle/ultisnips
RUN git clone https://github.com/honza/vim-snippets.git /etc/vim/bundle/vim-snippets
RUN git clone https://github.com/tpope/vim-fugitive.git /etc/vim/bundle/vim-fugitive
RUN git clone https://github.com/sukima/xmledit.git /etc/vim/bundle/xmledit
RUN git clone https://github.com/preservim/nerdtree.git /etc/vim/bundle/nerdtree
RUN git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git /etc/vim/bundle/nerdtree-git-plugin
RUN git clone https://github.com/lfv89/vim-interestingwords.git /etc/vim/bundle/vim-interestingwords

COPY configfiles/vimrc /etc/vim/
