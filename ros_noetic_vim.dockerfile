# This file tells docker what image must be created
# in order to be ahble to test this library
ARG ROS_DISTRO=noetic
FROM ros:${ROS_DISTRO}-ros-base

RUN apt clean
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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
                    vim vim-gtk \
                    && rm -rf /var/lib/apt/lists/*


RUN pip3 install cmakelang autopep8 pylint flake8 yamllint yamlfix yamlfmt

RUN npm install -g npm@latest-6
RUN npm install --save-dev --save-exact prettier
RUN npm install -g fixjson
RUN chmod 777 /etc/vim
RUN mkdir -p /etc/vim/bundle
RUN chmod 777 /etc/vim/bundle

RUN git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim
RUN git clone https://github.com/ycm-core/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe
RUN git clone https://github.com/vim-latex/vim-latex.git /etc/vim/bundle/vim-latex
RUN git clone https://github.com/preservim/tagbar.git /etc/vim/bundle/tagbar
RUN git clone https://github.com/jlanzarotta/bufexplorer.git /etc/vim/bundle/bufexplorer
RUN git clone https://github.com/dense-analysis/ale.git /etc/vim/bundle/ale
RUN git clone https://github.com/aklt/vim-substitute.git /etc/vim/bundle/vim-substitute
RUN git clone https://github.com/SirVer/ultisnips.git /etc/vim/bundle/ultisnips
RUN git clone https://github.com/honza/vim-snippets.git /etc/vim/bundle/vim-snippets
RUN git clone https://github.com/tpope/vim-fugitive.git /etc/vim/bundle/vim-fugitive
RUN git clone https://github.com/sukima/xmledit.git /etc/vim/bundle/xmledit
RUN git clone https://github.com/puremourning/vimspector.git /etc/vim/bundle/vimspector
RUN git clone https://github.com/preservim/nerdtree.git /etc/vim/bundle/nerdtree
RUN git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git /etc/vim/bundle/nerdtree-git-plugin
RUN git clone https://github.com/lfv89/vim-interestingwords.git /etc/vim/bundle/vim-interestingwords
RUN git clone https://github.com/kkoomen/vim-doge.git /etc/vim/bundle/vim-doge
RUN git clone https://github.com/rafaelrojasmiliani/vim_snippets_ros.git /etc/vim/bundle/vim-snippets-ros


RUN cd /etc/vim/bundle/YouCompleteMe && git submodule update --init --recursive && python3 install.py --clang-completer
# The next line was taken from https://github.com/ycm-core/YouCompleteMe/issues/3584
RUN export YCM_CORE=$(find /etc/vim/bundle/YouCompleteMe/third_party/ycmd/ -name 'ycm_core*.so') && patchelf --set-rpath "/etc/vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib" "$YCM_CORE"


RUN cd /etc/vim/bundle/vimspector && python3 install_gadget.py --enable-c --enable-cpp --enable-python

COPY configfiles/vimrc /etc/vim/
COPY configfiles/ycm_extra_conf.py /etc/vim/
COPY configfiles/ctags /etc/vim/
