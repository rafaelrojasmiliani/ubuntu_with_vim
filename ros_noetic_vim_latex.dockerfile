# This file tells docker what image must be created
# in order to be ahble to test this library
ARG ROS_DISTRO=noetic
FROM ros:${ROS_DISTRO}-ros-base

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    python3-pip git iputils-ping net-tools netcat screen   less \
                    python3-sympy coinor-libipopt-dev  valgrind \
                     pkg-config exuberant-ctags python3-catkin-tools \
                    liblapack-dev liblapack3 libopenblas-base libopenblas-dev \
                    libgfortran-7-dev cmake libgsl-dev gdb python3-tk libeigen3-dev \
                    libboost-math-dev build-essential cmake python3-dev mono-complete \
                    golang nodejs default-jdk npm clang-tidy-9 clang-format-10 \
                    apt-transport-https ca-certificates gnupg software-properties-common \
                    wget g++-8 golang clang jsonlint jq libxml2-utils patchelf python3-rosbag \
                    texlive-latex-extra texlive-pictures \
                    vim vim-gtk \
                    && rm -rf /var/lib/apt/lists/* && \
    pip3 install cmakelang autopep8 pylint flake8 yamllint yamlfix yamlfmt pylatex && \
    npm install -g npm@latest-6 && \
    npm install -g --save-dev --save-exact prettier && \
    npm install -g fixjson && \
    chmod 777 /etc/vim &&  mkdir -p /etc/vim/bundle && chmod 777 /etc/vim/bundle && \
    git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim && \
    git clone https://github.com/ycm-core/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe && \
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
    cd /etc/vim/bundle/YouCompleteMe && git submodule update --init --recursive && python3 install.py --clang-completer && \
        export YCM_CORE=$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_core*.so') && \
        patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$YCM_CORE" && \
        cd /etc/vim/bundle/vimspector && python3 install_gadget.py --enable-c --enable-cpp --enable-python

COPY configfiles/vimrc /etc/vim/
COPY configfiles/ycm_extra_conf.py /etc/vim/
COPY configfiles/ctags /etc/vim/
