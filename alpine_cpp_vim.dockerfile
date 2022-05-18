FROM alpine
RUN apk update \
    && apk add --no-cache vim gvim go clang-extra-tools g++ python3 py3-pip valgrind git bash make cmake gdb eigen-dev \
                            clang ctags gfortran nodejs openjdk11 npm libxml2-utils gnupg patchelf jq curl python3-dev \
                            linux-headers lapack-dev screen openblas-dev gtest-dev \
    && rm -rf /var/cache/apk/* \
    && git clone https://github.com/KarypisLab/GKlib.git \
    && cd GKlib \
    && make config prefix=/usr/ \
    && make -j2 \
    && make install \
    && cd .. \
    && rm -rf GKlib \
    && git clone https://github.com/KarypisLab/METIS.git \
    && cd METIS \
    && make config shared=1 cc=gcc prefix=/usr/ \
    && make -j2 \
    && make install \
    && cd .. \
    && rm -rf METIS \
    && git clone https://github.com/coin-or/Ipopt.git  \
    && cd Ipopt \
    && ./configure --with-lapack-lflags=-lopenblas --prefix=/usr/ \
    && make -j2 \
    && make install \
    && cd .. \
    && rm -rf Ipopt \
    && git clone https://github.com/ethz-adrl/ifopt.git /ifopt && cd /ifopt && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make -j2 && make install && cd .. \
    && cd .. \
    && rm -rf /ifopt && \
    npm install -g npm@latest-6 && \
    npm install -g --save-dev --save-exact prettier && \
    npm install -g fixjson && \
    chmod 777 /etc/vim &&  mkdir -p /etc/vim/bundle && chmod 777 /etc/vim/bundle && \
    git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim && \
    git clone https://github.com/tabnine/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe && \
    git clone https://github.com/vim-latex/vim-latex.git /etc/vim/bundle/vim-latex && \
    git clone https://github.com/preservim/tagbar.git /etc/vim/bundle/tagbar && \
    git clone https://github.com/jlanzarotta/bufexplorer.git /etc/vim/bundle/bufexplorer && \
    git clone https://github.com/dense-analysis/ale.git /etc/vim/bundle/ale && \
    git clone https://github.com/aklt/vim-substitute.git /etc/vim/bundle/vim-substitute && \
    git clone https://github.com/SirVer/ultisnips.git /etc/vim/bundle/ultisnips && \
    git clone https://github.com/honza/vim-snippets.git /etc/vim/bundle/vim-snippets && \
    git clone https://github.com/tpope/vim-fugitive.git /etc/vim/bundle/vim-fugitive && \
    git clone https://github.com/sukima/xmledit.git /etc/vim/bundle/xmledit && \
    git clone https://github.com/puremourning/vimspector.git /etc/vim/bundle/vimspector && \
    git clone https://github.com/preservim/nerdtree.git /etc/vim/bundle/nerdtree && \
    git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git /etc/vim/bundle/nerdtree-git-plugin && \
    git clone https://github.com/lfv89/vim-interestingwords.git /etc/vim/bundle/vim-interestingwords && \
    git clone https://github.com/kkoomen/vim-doge.git /etc/vim/bundle/vim-doge && \
    git clone https://github.com/rafaelrojasmiliani/vim_snippets_ros.git /etc/vim/bundle/vim-snippets-ros && \
    cd /etc/vim/bundle/YouCompleteMe && git submodule update --init --recursive && python3 install.py --clang-completer --force-sudo && \
        export YCM_CORE=$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_core*.so') && \
        patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$YCM_CORE" && \
        cd /etc/vim/bundle/vimspector && python3 install_gadget.py --enable-c --enable-cpp --enable-python \
   && rm -rf $(find /etc/vim/bundle -name .git) \
   && mkdir /workspace \
   && chmod 777 /workspace

COPY configfiles/vimrc /etc/vim/
COPY configfiles/ycm_extra_conf.py /etc/vim/
COPY configfiles/ctags /etc/vim/
COPY configfiles/gdbinit /etc/gdb/
COPY configfiles/printers.py /etc/gdb/

#    && pip install cmakelang autopep8 pylint flake8 \
#                 yamllint yamlfix yamlfmt setuptools matplotlib \
#                 scipy quadpy six cython tk && \
