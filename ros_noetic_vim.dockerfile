# This file tells docker what image must be created
# in order to be ahble to test this library
FROM ros:noetic-ros-base
SHELL ["bash", "-c"]
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
                    wget g++-8 golang clang jsonlint jq libxml2-utils patchelf \
                    python3-flask \
                    ros-noetic-control-msgs \
                    ros-noetic-velocity-controllers \
                    ros-noetic-joint-trajectory-action \
                    ros-noetic-ifopt \
                    ros-noetic-plotjuggler \
                    ros-noetic-joint-trajectory-controller \
                    ros-noetic-joint-trajectory-action \
                    ros-noetic-xacro \
                    ros-noetic-gazebo-ros \
                    ros-noetic-gazebo-ros-control \
                    ros-noetic-joint-state-controller \
                    ros-noetic-position-controllers \
                    ros-noetic-robot-state-publisher \
                    ros-noetic-joint-state-publisher \
                    ros-noetic-rqt \
                    ros-noetic-rqt-graph \
                    ros-noetic-roslint \
                    ros-noetic-plotjuggler-ros \
                    ros-noetic-rqt-gui \
                    ros-noetic-rqt-gui-py \
                    ros-noetic-rqt-py-common \
                    ros-noetic-moveit-msgs \
                    ros-noetic-rqt-joint-trajectory-controller \
                    ros-noetic-jsk-rviz-plugins  \
                    vim vim-gtk \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/ws/src \
    && git clone https://github.com/rafaelrojasmiliani/ur_description_minimal.git /root/ws/src \
    && cd /root/ws \
    && source /opt/ros/noetic/setup.bash \
    && catkin config --install --install-space /opt/ros/noetic/ --extend /opt/ros/noetic/ \
    && catkin build \
    && rm -rf /ws/* \
    && cd / && \
    pip3 install cmakelang autopep8 pylint flake8 yamllint yamlfix yamlfmt  rospkg numpy scipy && \
    npm install -g npm@latest-6 && \
    npm install -g htmlhint && \
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
        chmod 777 -R *  && \
        cd /etc/vim/bundle/vimspector && python3 install_gadget.py --enable-c --enable-cpp --enable-python \
   && rm -rf $(find /etc/vim/bundle -name .git) \
   && echo 'source /opt/ros/noetic/setup.bash' > /etc/bash.bashrc \
   && mkdir /workspace \
   && chmod 777 /workspace

COPY configfiles/vimrc /etc/vim/
COPY configfiles/ycm_extra_conf_ros.py /etc/vim/ycm_extra_conf.py
COPY configfiles/ctags /etc/vim/
COPY configfiles/gdbinit /etc/gdb/
COPY configfiles/printers.py /etc/gdb/
