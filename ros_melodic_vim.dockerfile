# This file tells docker what image must be created
# in order to be ahble to test this library
FROM ros:melodic-ros-base
SHELL ["bash", "-c"]
# Install packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
        -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
        software-properties-common ca-certificates gnupg wget curl \
    && add-apt-repository ppa:jonathonf/vim -y \
    && bash -c 'wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -' \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    python3-pip git iputils-ping net-tools netcat screen   less \
                    python3-sympy coinor-libipopt-dev  valgrind \
                     pkg-config exuberant-ctags python3-catkin-tools \
                    liblapack-dev liblapack3 libopenblas-base libopenblas-dev \
                    libgfortran-7-dev cmake libgsl-dev gdb python3-tk libeigen3-dev \
                    libboost-math-dev build-essential cmake python3-dev mono-complete \
                    golang nodejs default-jdk clang-tidy-9 clang-format-10 \
                    apt-transport-https libgtest-dev  \
                    python3-flask \
                    g++-8 golang clang clang-format clang-tidy jsonlint jq libxml2-utils patchelf \
                    ros-melodic-control-msgs \
                    ros-melodic-velocity-controllers \
                    ros-melodic-joint-trajectory-action \
                    ros-melodic-ifopt \
                    ros-melodic-plotjuggler \
                    ros-melodic-joint-trajectory-controller \
                    ros-melodic-joint-trajectory-action \
                    ros-melodic-xacro \
                    ros-melodic-gazebo-ros \
                    ros-melodic-gazebo-ros-control \
                    ros-melodic-joint-state-controller \
                    ros-melodic-position-controllers \
                    ros-melodic-robot-state-publisher \
                    ros-melodic-joint-state-publisher \
                    ros-melodic-rqt \
                    ros-melodic-rqt-graph \
                    ros-melodic-roslint \
                    ros-melodic-plotjuggler-ros \
                    ros-melodic-rqt-gui \
                    ros-melodic-rqt-gui-py \
                    ros-melodic-rqt-py-common \
                    ros-melodic-moveit-msgs \
                    ros-melodic-rqt-joint-trajectory-controller \
                    ros-melodic-jsk-rviz-plugins  \
                    vim vim-gtk \
    && mkdir /usr/src/gtest/build && cd /usr/src/gtest/build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make -j2 \
    && make install \
    && cd / \
    && rm -rf /usr/src/gtest/build \
    && pip3 install cmakelang autopep8 pylint flake8 prospector yamllint yamlfix yamlfmt \
    && update-alternatives --install /usr/bin/gcc gcc \
			/usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7 \
    && update-alternatives --install /usr/bin/gcc gcc \
			/usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8 \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install nodejs \
    && npm install -g npm@latest-6 \
    && npm install -g --save-dev --save-exact prettier \
    && npm install -g fixjson \
    && rm -rf /var/lib/apt/lists/*  \
    && mkdir -p /root/ws/src \
    && git clone https://github.com/rafaelrojasmiliani/ur_description_minimal.git /root/ws/src \
    && cd /root/ws \
    && source /opt/ros/melodic/setup.bash \
    && catkin config --install --install-space /opt/ros/melodic/ --extend /opt/ros/melodic/ \
    && catkin build \
    && rm -rf /root/ws \
    && cd / && \
    pip3 install cmakelang autopep8 pylint flake8 yamllint yamlfix yamlfmt && \
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
        chmod 777 -R *  && \
        cd /etc/vim/bundle/vimspector && python3 install_gadget.py --enable-c --enable-cpp --enable-python \
   && rm -rf $(find /etc/vim/bundle -name .git) \
   && echo 'source /opt/ros/melodic/setup.bash' > /etc/bash.bashrc \
   && mkdir /workspace \
   && chmod 777 /workspace


COPY configfiles/vimrc /etc/vim/
COPY configfiles/ycm_extra_conf_ros.py /etc/vim/ycm_extra_conf.py
COPY configfiles/ctags /etc/vim/
COPY configfiles/gdbinit /etc/gdb/
COPY configfiles/printers.py /etc/gdb/
