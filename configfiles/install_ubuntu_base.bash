#!/bin/bash

main() {
    set -xe
    echo 'Etc/UTC' >/etc/timezone &&
        ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime &&
        apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            apt-transport-https \
            build-essential \
            ca-certificates \
            ccache \
            cmake \
            cmake-curses-gui \
            cmake-curses-gui \
            cmake-qt-gui \
            coinor-libipopt-dev \
            curl \
            default-jdk \
            dialog \
            dirmngr \
            exuberant-ctags \
            flawfinder \
            g++ \
            gdb \
            git \
            git-lfs \
            gnupg \
            gnupg2 \
            golang \
            iproute2 \
            iputils-ping \
            jq \
            jsonlint \
            less \
            libboost-math-dev \
            libeigen3-dev \
            libgmp3-dev \
            libgsl-dev \
            libgtest-dev \
            libjpeg-dev \
            liblapack-dev \
            liblapack3 \
            libmpc-dev \
            libncurses-dev \
            libopenblas-base \
            libopenblas-dev \
            librsvg2-dev \
            libsuitesparse-dev \
            libsvgpp-dev \
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
            python3-argcomplete \
            python3-dev \
            python3-pip \
            screen \
            silversearcher-ag \
            software-properties-common \
            sudo \
            terminator \
            tmux \
            tzdata \
            unzip \
            valgrind \
            vim \
            vim-gtk \
            vim-nox \
            wget \
            zenity

    # --------------------
    # Install latest vim
    # -------------------
    echo -ne '\n' | apt-add-repository ppa:jonathonf/vim
    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o \
            Dpkg::Options::="--force-confnew" vim

    if [ $DISTRIB_RELEASE = "18.04" ]; then
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            python3-setuptools
    fi

    # --------------------
    # Install rust
    # -------------------
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
        sh -s -- --default-toolchain stable -y

    export PATH=/root/.cargo/bin:$PATH

    # --------------------
    # Install arduino-cli
    # -------------------
    cd / &&
        wget -qO arduino-cli.tar.gz \
            https://downloads.arduino.cc/arduino-cli/arduino-cli_ \
            latest_Linux_64bit.tar.gz &&
        tar xf arduino-cli.tar.gz -C /usr/local/bin arduino-cli &&
        rm -rf /arduino-cli.tar.gz &&
        arduino-cli completion bash >/etc/bash_completion.d/arduino-cli.sh &&
        arduino-cli core install arduino:avr

    source /etc/lsb-release

    git clone https://github.com/universal-ctags/ctags.git /ctags &&
        cd /ctags &&
        ./autogen.sh &&
        ./configure --prefix=/usr &&
        make &&
        make install # may require extra privileges depending on where to install

    # --------------------
    # Install latest cmake
    # -------------------
    cd /
    [ ! dpkg --verify cmake ] 2>/dev/null &&
        apt remove --purge --auto-remove -y cmake
    wget -O - \
        https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null |
        gpg --dearmor - |
        tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null &&
        echo -ne '\n' | apt-add-repository \
            "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" &&
        apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o \
            Dpkg::Options::="--force-confnew" cmake \
            cmake-curses-gui cmake-qt-gui

    # -----------------
    # Install hadolint: dockerfile lineter
    # -----------------
    curl -LJ https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 --output /usr/bin/hadolint
    chmod +x /usr/bin/hadolint

    # -----------------
    # Install shfmt, bash formatter
    # -----------------
    curl -LJ https://github.com/patrickvane/shfmt/releases/download/master/shfmt_linux_amd64 --output /usr/bin/shfmt

    chmod +x /usr/bin/shfmt

    if [ $DISTRIB_RELEASE = "18.04" ]; then
        # 1. Install ripgrep and bat from github releases
        # 3. update gcc to one compatible with c++17
        # 4. install gtest
        # --------------------
        # 1. Install ripgrep
        # -------------------
        cd / &&
            wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb &&
            wget https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb &&
            dpkg -i *.deb &&
            rm *deb
        # --------------------
        # 3. Install gcc compatible with c++17
        # -------------------
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            gcc-8 g++-8

        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 \
            --slave /usr/bin/g++ g++ /usr/bin/g++-7
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 \
            --slave /usr/bin/g++ g++ /usr/bin/g++-8

        # --------------------
        # 4. Install Gtest
        # -------------------
        mkdir -p /usr/src/gtest/build && cd /usr/src/gtest/build &&
            cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make -j$(nproc) &&
            make install &&
            cd / &&
            rm -rf /usr/src/gtest/build

        pip3 install setuptools

        # --- Install pinocchio
        echo "deb [arch=amd64] \
            http://robotpkg.openrobots.org/packages/debian/pub \
        $(lsb_release -cs) robotpkg" |
            tee /etc/apt/sources.list.d/robotpkg.list
        curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key |
            apt-key add -
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            robotpkg-py36-pinocchio

        # --------------------
        # Install latest clang
        # -------------------
        dcn=$(lsb_release -sc)
        echo \
            "deb http://apt.llvm.org/$dcn/ llvm-toolchain-$dcn main" \
            >>/etc/apt/sources.list &&
            wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key |
            apt-key add - &&
            echo -ne '\n' | add-apt-repository ppa:ubuntu-toolchain-r/test &&
            apt-get update &&
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                clang-format \
                clang-tidy \
                clang \
                clangd \
                libc++-dev \
                libc++1 \
                libc++abi-dev \
                libc++abi1 \
                libclang-dev \
                libclang1 \
                libllvm-ocaml-dev \
                lld \
                llvm-dev \
                llvm-runtime \
                llvm

        wget https://github.com/sharkdp/fd/releases/download/v8.7.0/fd-musl_8.7.0_amd64.deb
        dpkg -i fd-musl_8.7.0_amd64.deb && rm fd-musl_8.7.0_amd64.deb
        pip3 install numpy
    else
        # ubuntu 20.04 and 22.04

        # ----------------------
        # Install latest clang
        # ----------------------

        bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" -- all
        clang_version=$(dpkg -l | grep '\<clang\>-[0-9]\+' | awk '{print $2}' | sed -e 's/clang-//')
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            liblldb-$clang_version-dev \
            python3-clang-$clang_version

        # ---------------------------------------------
        # --- Install Open MP compatible with clang
        # ---------------------------------------------
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            "libomp-$clang_version-dev"

        echo "export PATH=/usr/lib/llvm-$clang_version/bin:$PATH" >>/etc/bash.bashrc

        # ---------------------------------------------
        # ----    Install nice stuff  ----------------
        # ---------------------------------------------

        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            bat \
            npm \
            ripgrep \
            librange-v3-dev \
            ccls \
            fd-find \
            libasan5
        npm install -g --save-dev --save-exact npm@latest-6
        npm install -g --save-dev --save-exact htmlhint prettier fixjson

        # ---------------------------------------------
        # --- Install pinocchio -----------------------
        # ---------------------------------------------
        echo "deb [arch=amd64] \
            http://robotpkg.openrobots.org/packages/debian/pub \
        $(lsb_release -cs) robotpkg" |
            tee /etc/apt/sources.list.d/robotpkg.list
        curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key |
            apt-key add -
        apt-get update
        if [ $DISTRIB_RELEASE = "20.04" ]; then

            add-apt-repository -y ppa:ubuntu-toolchain-r/test
            apt-get update
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends \
                -o Dpkg::Options::="--force-confnew" \
                robotpkg-py38-pinocchio \
                gcc-11 g++-11

            update-alternatives \
                --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 \
                --slave /usr/bin/g++ g++ /usr/bin/g++-9 \
                --slave /usr/bin/gcov gcov /usr/bin/gcov-9 \
                --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-9 \
                --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-9 &&
                update-alternatives \
                    --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 \
                    --slave /usr/bin/g++ g++ /usr/bin/g++-11 \
                    --slave /usr/bin/gcov gcov /usr/bin/gcov-11 \
                    --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 \
                    --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11

            pip3 install numpy==1.20 pyrender
        else

            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends \
                -o Dpkg::Options::="--force-confnew" \
                robotpkg-py310-pinocchio
            pip3 install numpy pyrender
        fi

    fi

    pip3 install \
        autopep8 \
        cmake-format \
        flake8 \
        flask \
        pip \
        sympy \
        pandas \
        tk \
        scipy \
        matplotlib \
        bashate

    git config --global merge.tool vimdiff
    git config --global merge.conflictstyle diff3

    # --- Allow to install firefox

    echo -ne '\n' | add-apt-repository ppa:mozillateam/ppa
    echo '
    Package: *
    Pin: release o=LP-PPA-mozillateam
    Pin-Priority: 1001
    ' | tee /etc/apt/preferences.d/mozilla-firefox

    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' |
        tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

    # --- Install ifopt
    git clone https://github.com/ethz-adrl/ifopt.git /ifopt
    cd /ifopt
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
    make -j$(nproc)
    make install
    cd /
    rm -rf /ifopt

    # --- Install Mosek
    cd /
    wget https://download.mosek.com/stable/9.3.20/mosektoolslinux64x86.tar.bz2
    tar xf /mosektoolslinux64x86.tar.bz2 -C /
    cd /mosek/9.3/tools/platform/linux64x86/src/fusion_cxx
    make -j$(nproc) && make install
    install /mosek/9.3/tools/platform/linux64x86/bin/* /usr/lib/
    install /mosek/9.3/tools/platform/linux64x86/h/* /usr/include/
    cd /
    rm -rf /mosek

    pip3 install Mosek

    # --- Install osqp
    cd /
    git clone --recurse-submodules --branch v0.6.3 https://github.com/osqp/osqp.git
    cd osqp &&
        mkdir build &&
        cd build &&
        cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make -j$(proc) && make install

}

main
