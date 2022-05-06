FROM moveit/moveit:noetic-release

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    python3-pip git iputils-ping net-tools netcat screen   less \
                    python3-sympy coinor-libipopt-dev  valgrind \
                     pkg-config exuberant-ctags \
                    liblapack-dev liblapack3 libopenblas-base libopenblas-dev \
                    libgfortran-7-dev cmake libgsl-dev gdb python3-tk libeigen3-dev \
                    libboost-math-dev build-essential cmake python3-dev mono-complete \
                    golang nodejs default-jdk npm clang-tidy-9 clang-format-10 \
                    apt-transport-https ca-certificates gnupg software-properties-common \
                    wget g++-8 golang clang jsonlint jq libxml2-utils patchelf \
                    vim vim-gtk \
                    ros-noetic-moveit-msgs \
                    ros-noetic-geometric-shapes \
                    ros-noetic-moveit-resources-fanuc-moveit-config \
                    ros-noetic-moveit-resources-fanuc-description \
                    ros-noetic-moveit-resources-panda-description \
                    ros-noetic-moveit-resources-panda-moveit-config \
                    ros-noetic-moveit-resources-pr2-description \
                    ros-noetic-srdfdom \
                    ros-noetic-ifopt \
                    ros-noetic-moveit-resources-prbt-moveit-config \
                    ros-noetic-moveit-resources-prbt-support \
                    ros-noetic-moveit-resources-prbt-pg70-support \
   &&  apt-get clean \
   &&  cd / \
   &&  wget https://github.com/rafaelrojasmiliani/gsplines_cpp/releases/download/package/gsplines-0.0.1-amd64.deb \
   &&  dpkg -i gsplines-0.0.1-amd64.deb \
   &&  rm gsplines-0.0.1-amd64.deb \
   &&  rm -rf /var/lib/apt/lists/* \
   &&  pip3 install cmakelang autopep8 pylint flake8 yamllint yamlfix yamlfmt \
   &&  npm install -g npm@latest-6 \
   &&  npm install --save-dev --save-exact prettier \
   &&  npm install -g fixjson \
   &&  chmod 777 /etc/vim \
   &&  mkdir -p /etc/vim/bundle \
   &&  chmod 777 /etc/vim/bundle \
   &&  git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim \
   &&  git clone https://github.com/tabnine/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe \
   &&  git clone https://github.com/vim-latex/vim-latex.git /etc/vim/bundle/vim-latex \
   &&  git clone https://github.com/preservim/tagbar.git /etc/vim/bundle/tagbar \
   &&  git clone https://github.com/jlanzarotta/bufexplorer.git /etc/vim/bundle/bufexplorer \
   &&  git clone https://github.com/dense-analysis/ale.git /etc/vim/bundle/ale \
   &&  git clone https://github.com/aklt/vim-substitute.git /etc/vim/bundle/vim-substitute \
   &&  git clone https://github.com/SirVer/ultisnips.git /etc/vim/bundle/ultisnips \
   &&  git clone https://github.com/honza/vim-snippets.git /etc/vim/bundle/vim-snippets \
   &&  git clone https://github.com/tpope/vim-fugitive.git /etc/vim/bundle/vim-fugitive \
   &&  git clone https://github.com/sukima/xmledit.git /etc/vim/bundle/xmledit \
   &&  git clone https://github.com/puremourning/vimspector.git /etc/vim/bundle/vimspector \
   &&  git clone https://github.com/preservim/nerdtree.git /etc/vim/bundle/nerdtree \
   &&  git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git /etc/vim/bundle/nerdtree-git-plugin \
   &&  git clone https://github.com/lfv89/vim-interestingwords.git /etc/vim/bundle/vim-interestingwords \
   &&  git clone https://github.com/kkoomen/vim-doge.git /etc/vim/bundle/vim-doge \
   &&  git clone https://github.com/rafaelrojasmiliani/vim_snippets_ros.git /etc/vim/bundle/vim-snippets-ros \
   &&  cd /etc/vim/bundle/YouCompleteMe \
   &&  git submodule update --init --recursive \
   &&  python3 install.py --clang-completer --force-sudo  \
   &&  export YCM_CORE=$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_core*.so') \
   &&  patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$YCM_CORE"  \
   &&  chmod 777 -R *  \
   && rm -rf $(find /etc/vim/bundle -name .git) \
   &&  cd /etc/vim/bundle/vimspector \
   &&  python3 install_gadget.py --enable-c --enable-cpp --enable-python \
   &&  echo 'source /opt/ros/noetic/setup.bash' > /etc/bash.bashrc \
   &&  mkdir /workspace \
   &&  chmod 777 /workspace

COPY configfiles/vimrc /etc/vim/
COPY configfiles/ycm_extra_conf_ros.py /etc/vim/ycm_extra_conf.py



# The next line was taken from https://github.com/ycm-core/YouCompleteMe/issues/3584
#RUN patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_core*.so')"
