


main(){
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            cmake-curses-gui \
            cmake-qt-gui \
            curl \
            lsb-core \
            gnupg2 \
            apt-transport-https \
            build-essential \
            ca-certificates \
            clang \
            clangd \
            clang-format \
            clang-tidy \
            cmake \
            libncurses-dev \
            cmake-curses-gui \
            coinor-libipopt-dev \
            default-jdk \
            exuberant-ctags \
            g++ \
            gdb \
            git \
            gnupg \
            golang \
            iputils-ping \
            jq \
            jsonlint \
            less \
            libboost-math-dev \
            libeigen3-dev \
            libgmp3-dev \
            libgsl-dev \
            libgtest-dev \
            liblapack-dev \
            liblapack3 \
            libmpc-dev \
            libopenblas-base \
            libopenblas-dev \
            libsuitesparse-dev \
            libtrilinos-trilinosss-dev \
            libxml2-utils \
            mono-complete \
            net-tools \
            netcat \
            nodejs \
            npm \
            patchelf \
            pkg-config \
            pylint \
            screen \
            silversearcher-ag \
            software-properties-common \
            sudo \
            unzip \
            valgrind \
            vim \
            vim-gtk \
            vim-nox \
            wget \
            python3-pip \
            python3-dev \
            llvm-dev \
            libclang-dev \
            libomp-dev \
    && pip3 install \
            autopep8 \
            flake8 \
            flask \
            pip \
            sympy \
            tk

    npm install -g --save-dev --save-exact npm@latest-6
    npm install -g --save-dev --save-exact htmlhint prettier fixjson
source /etc/lsb-release

if [ $DISTRIB_RELEASE = "18.04" ]; then
    # 1. Install ripgrep and bat from github releases
    # 2. install lastest cmake
    # 3. update gcc to one compatible with c++17
    # 4. install latest vim
    # 5. install gtest
    cd / \
    && wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb \
    && wget https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb \
    && dpkg -i *.deb \
    && rm *deb
    # --------------------
    # 2. Install latest cmake
    # -------------------
    cd / && sudo apt remove --purge --auto-remove -y cmake \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
            gpg --dearmor - | \
            tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null \
    && apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" cmake \
            cmake-curses-gui \
            cmake-qt-gui

    # --------------------
    # 3. Install gcc compatible with c++17
    # -------------------
    DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" gcc-8 g++-8

    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8

    # --------------------
    # 4. Install latest vim
    # -------------------
    apt-add-repository ppa:jonathonf/vim
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" vim

    # --------------------
    # 5. Install Gtest
    # -------------------
    mkdir /usr/src/gtest/build && cd /usr/src/gtest/build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf /usr/src/gtest/build


else
    DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                bat \
                ripgrep
fi
}


main
