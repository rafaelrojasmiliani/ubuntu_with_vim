#!/bin/bash


main(){
    set -x
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            software-properties-common \
            apt-transport-https \
            build-essential \
            ca-certificates \
            ccls  \
            flawfinder \
            cmake \
            cmake-curses-gui \
            cmake-curses-gui \
            cmake-qt-gui \
            coinor-libipopt-dev \
            curl \
            default-jdk \
            exuberant-ctags \
            g++ \
            gdb \
            git \
            gnupg \
            gnupg2 \
            golang \
            iputils-ping \
            jq \
            jsonlint \
            less \
            tmux \
            libboost-math-dev \
            libeigen3-dev \
            libgmp3-dev \
            libgsl-dev \
            libgtest-dev \
            liblapack-dev \
            liblapack3 \
            libmpc-dev \
            libncurses-dev \
            libopenblas-base \
            libopenblas-dev \
            libsuitesparse-dev \
            libtrilinos-trilinosss-dev \
            libxml2-utils \
            lsb-core \
            mono-complete \
            net-tools \
            netcat \
            nodejs \
            patchelf \
            pkg-config \
            pybind11-dev \
            pylint \
            python3-dev \
            python3-pip \
            screen \
            silversearcher-ag \
            software-properties-common \
            sudo \
            terminator \
            unzip \
            valgrind \
            vim \
            vim-gtk \
            vim-nox \
            wget \
    && pip3 install \
            autopep8 \
            cmake-format \
            flake8 \
            flask \
            pip \
            sympy \
            numpy \
            pandas \
            tk \
            scipy \
            matplotlib \
            bashate
    # --------------------
    # Install rust
    # -------------------
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y

    export PATH=/root/.cargo/bin:$PATH

    # --------------------
    # Install arduino-cli
    # -------------------
    cd / \
        && wget -qO arduino-cli.tar.gz https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz \
        && tar xf arduino-cli.tar.gz -C /usr/local/bin arduino-cli \
        && rm -rf /arduino-cli.tar.gz && arduino-cli completion bash > /etc/bash_completion.d/arduino-cli.sh \
        && arduino-cli core install arduino:avr



    source /etc/lsb-release

    git clone https://github.com/universal-ctags/ctags.git /ctags \
        && cd /ctags \
        && ./autogen.sh \
        && ./configure --prefix=/usr \
        && make \
        && make install # may require extra privileges depending on where to install


    # --------------------
    # Install latest cmake
    # -------------------
    cd /
    [ ! dpkg --verify cmake 2>/dev/null ] && apt remove --purge --auto-remove -y cmake
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
            gpg --dearmor - | \
            tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null \
    && apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" cmake \
            cmake-curses-gui \
            cmake-qt-gui

    # --------------------
    # Install latest clant
    # -------------------
    local distcodename=$(lsb_release -sc)
    echo "deb http://apt.llvm.org/$distcodename/ llvm-toolchain-$distcodename main" >> /etc/apt/sources.list \
        && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - \
        && add-apt-repository ppa:ubuntu-toolchain-r/test \
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install \
                    -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    clang-format \
                    clang-tidy \
                    clang-tools \
                    clang \
                    clangd \
                    libc++-dev \
                    libc++1 \
                    libc++abi-dev \
                    libc++abi1 \
                    libclang-dev \
                    libclang1 \
                    liblldb-dev \
                    libllvm-ocaml-dev \
                    libomp-dev \
                    libomp5 \
                    lld \
                    llvm-dev \
                    llvm-runtime \
                    llvm \
                    python3-clang

    # -----------------
    # Install hadolint: dockerfile lineter
    # -----------------
    curl -LJ  https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 --output /usr/bin/hadolint

    if [ $DISTRIB_RELEASE = "18.04" ]; then
        # 1. Install ripgrep and bat from github releases
        # 3. update gcc to one compatible with c++17
        # 4. install latest vim
        # 5. install gtest
        # --------------------
        # 1. Install ripgrep
        # -------------------
        cd / \
        && wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb \
        && wget https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb \
        && dpkg -i *.deb \
        && rm *deb
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
        mkdir -p /usr/src/gtest/build && cd /usr/src/gtest/build \
        && cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make -j$(nproc) \
        && make install \
        && cd / \
        && rm -rf /usr/src/gtest/build


    else
        DEBIAN_FRONTEND=noninteractive apt-get install \
                        -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    bat \
                    clangd \
                    npm \
                    ripgrep \
                    librange-v3-dev \
                    libasan5
        npm install -g --save-dev --save-exact npm@latest-6
        npm install -g --save-dev --save-exact htmlhint prettier fixjson
    fi

    git config --global merge.tool vimdiff
    git config --global merge.conflictstyle diff3

    # --- Install ifopt
    if [ ! -d /opt/ros ]; then
        source /workspace/configfiles/install_ifopt.bash
        install_ifopt
    fi
}


main
