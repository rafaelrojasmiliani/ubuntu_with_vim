#!/bin/bash

main() {
    set -xeu
    echo 'Etc/UTC' >/etc/timezone &&
        ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime &&
        apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            apt-rdepends \
            apt-transport-https \
            build-essential \
            ca-certificates \
            ccache \
            cmake \
            cmake-curses-gui \
            cmake-qt-gui \
            coinor-libipopt-dev \
            cppcheck-gui \
            curl \
            default-jdk \
            dialog \
            dirmngr \
            exuberant-ctags \
            flawfinder \
            g++ \
            gdb \
            gfortran \
            git \
            git-lfs \
            gitk \
            gnupg \
            gnupg2 \
            golang \
            iproute2 \
            iputils-ping \
            jq \
            jsonlint \
            less \
            libatlas3-base \
            libboost-math-dev \
            libczmq-dev \
            libeigen3-dev \
            libfmt-dev \
            libgmp3-dev \
            libgsl-dev \
            libgtest-dev \
            libjpeg-dev \
            liblapack-dev \
            liblapack3 \
            libmpc-dev \
            libncurses-dev \
            libopenblas-dev \
            liborocos-kdl-dev \
            librsvg2-dev \
            libsqlite3-dev \
            libsuitesparse-dev \
            libsvgpp-dev \
            libtrilinos-trilinosss-dev \
            libxml2-utils \
            mono-complete \
            net-tools \
            openjdk-21-jdk \
            patchelf \
            pciutils \
            pkg-config \
            pybind11-dev \
            pylint \
            python3-argcomplete \
            python3-dev \
            python3-pip \
            python3-venv \
            python3-virtualenv \
            screen \
            silversearcher-ag \
            software-properties-common \
            subversion \
            sudo \
            terminator \
            tmux \
            tzdata \
            unzip \
            usbutils \
            valgrind \
            vim \
            vim-nox \
            wget \
            zenity

    DISTRIB_RELEASE=$(lsb_release -sr 2>/dev/null)

    if [ $DISTRIB_RELEASE = "24.04" ]; then
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            netcat-openbsd \
            ncat \
            vim-gtk3 \
            locales \
            lsb-base
    else
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            netcat \
            libkdl-parser-dev \
            vim-gtk \
            lsb-core
        # --------------------
        # Install latest vim
        # -------------------
        echo -ne '\n' | apt-add-repository ppa:jonathonf/vim
        apt-get update &&
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o \
                Dpkg::Options::="--force-confnew" vim
    fi

    if [ $DISTRIB_RELEASE = "18.04" ]; then
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            python3-setuptools
    fi

    # -----------------------------
    # Install rust
    # -----------------------------
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
        sh -s -- --default-toolchain stable -y

    export PATH=/root/.cargo/bin:$PATH

    # -----------------------------
    # Install arduino-cli
    # -----------------------------
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
    rm -rf /ctags

    mkdir /difftastic &&
        wget -q https://github.com/Wilfred/difftastic/releases/download/0.65.0/difft-x86_64-unknown-linux-gnu.tar.gz -O /difftastic/difftastic.tar.gz &&
        tar -xvf /difftastic/difftastic.tar.gz -C /difftastic/ &&
        mv /difftastic/difft /usr/local/bin/ &&
        rm -rf /difftastic

    # -----------------------------
    # Install latest cmake
    # -----------------------------
    if [ $DISTRIB_RELEASE != "24.04" ]; then
        cd /
        if ! dpkg --verify cmake 2>/dev/null; then
            apt remove --purge --auto-remove -y cmake
        fi
        wget -O - \
            https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null |
            gpg --dearmor - |
            tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null &&
            echo -ne '\n' | apt-add-repository \
                "deb https://apt.kitware.com/ubuntu/ $(lsb_release 2>/dev/null -cs) main" &&
            apt-get update &&
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o \
                Dpkg::Options::="--force-confnew" cmake \
                cmake-curses-gui cmake-qt-gui
    fi
    # -----------------
    # Install hadolint: dockerfile lineter
    # -----------------
    curl -LJ https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 --output /usr/bin/hadolint
    chmod +x /usr/bin/hadolint

    # -----------------
    # Install actionlint: github action linter
    # -----------------
    cd /
    bash <(curl https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash) latest /usr/bin

    # -----------------
    # Install shfmt, bash formatter
    # -----------------
    curl -LJ https://github.com/patrickvane/shfmt/releases/download/master/shfmt_linux_amd64 --output /usr/bin/shfmt

    chmod +x /usr/bin/shfmt

    if [ $DISTRIB_RELEASE = "20.04" ]; then
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o \
            Dpkg::Options::="--force-confnew" python3.8-venv
    fi
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

        pip3 install --no-cache-dir setuptools

        # --- Install pinocchio
        # echo "deb [arch=amd64] \
        #     http://robotpkg.openrobots.org/packages/debian/pub \
        # $(lsb_release 2>/dev/null -cs) robotpkg" |
        #     tee /etc/apt/sources.list.d/robotpkg.list
        # curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key |
        #     apt-key add -
        # apt-get update
        # DEBIAN_FRONTEND=noninteractive apt-get install \
        #     -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
        #     robotpkg-py36-pinocchio

        # --------------------
        # Install latest clang
        # -------------------
        dcn=$(lsb_release 2>/dev/null -sc)
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
        pip3 install --no-cache-dir wheel
        pip3 install --no-cache-dir numpy

        # ----------------------
        # Install nodejs
        # ----------------------
        mkdir /opt/nvm
        export NVM_DIR=/opt/nvm
        cd /opt/nvm
        wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh
        bash install.sh
        source nvm.sh
        nvm install 22
        echo 'source /opt/nvm/nvm.sh' >>/etc/bash.bashrc
    else
        # ubuntu 20.04 and 22.04 and 24.04

        if [ $DISTRIB_RELEASE != "24.04" ]; then
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

        else

            clang_version=19
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                clang-$clang_version \
                clang-format-$clang_version \
                clang-tidy-$clang_version \
                clang-tools-$clang_version \
                clangd-$clang_version \
                libclang-$clang_version-dev \
                libclang-common-$clang_version-dev:amd64 \
                libclang-cpp$clang_version \
                libclang-cpp$clang_version-dev \
                libclang-rt-$clang_version-dev:amd64 \
                libclang1-$clang_version \
                libomp-$clang_version-dev \
                lld-$clang_version \
                llvm-$clang_version \
                python3-clang-$clang_version

        fi
        echo "export PATH=/usr/lib/llvm-$clang_version/bin:$PATH" >>/etc/bash.bashrc

        # ---------------------------------------------
        # ----    Install nice stuff  ----------------
        # ---------------------------------------------

        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            bat \
            ripgrep \
            librange-v3-dev \
            fd-find \
            libasan5

        # ---------------------------------------------
        # --- Install pinocchio -----------------------
        # ---------------------------------------------
        if [ $DISTRIB_RELEASE = "20.04" ]; then

            echo "deb [arch=amd64] \
            http://robotpkg.openrobots.org/packages/debian/pub \
        $(lsb_release 2>/dev/null -cs) robotpkg" |
                tee /etc/apt/sources.list.d/robotpkg.list
            curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key |
                apt-key add -
            apt-get update
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

            pip3 install --no-cache-dir numpy==1.20 pyrender
            echo 'export PYTHONPATH=/opt/openrobots/lib/python3.8/site-packages:$PYTHONPATH # Adapt your desired python version here' >>/etc/bash.bashrc
        else

            echo "deb [arch=amd64] \
            http://robotpkg.openrobots.org/packages/debian/pub \
        jammy robotpkg" |
                tee /etc/apt/sources.list.d/robotpkg.list
            curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key |
                apt-key add -
            apt-get update
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends \
                -o Dpkg::Options::="--force-confnew" \
                robotpkg-py310-pinocchio \
                kotlin
            if [ $DISTRIB_RELEASE != "24.04" ]; then
                pip3 install --no-cache-dir numpy pyrender
            fi

            echo 'export PYTHONPATH=/opt/openrobots/lib/python3.10/site-packages:$PYTHONPATH # Adapt your desired python version here' >>/etc/bash.bashrc
        fi

        echo 'export PATH=/opt/openrobots/bin:$PATH' >>/etc/bash.bashrc
        echo 'export PKG_CONFIG_PATH=/opt/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH' >>/etc/bash.bashrc
        echo 'export LD_LIBRARY_PATH=/opt/openrobots/lib:$LD_LIBRARY_PATH' >>/etc/bash.bashrc
        echo 'export CMAKE_PREFIX_PATH=/opt/openrobots:$CMAKE_PREFIX_PATH' >>/etc/bash.bashrc

        # ----------------------
        # Install nodejs
        # ----------------------
        mkdir /opt/nvm
        export NVM_DIR=/opt/nvm
        cd /opt/nvm
        wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh
        bash install.sh
        source nvm.sh
        nvm install 22
        echo 'source /opt/nvm/nvm.sh' >>/etc/bash.bashrc
        npm install -g --save-dev --save-exact htmlhint prettier fixjson

    fi

    if [ $DISTRIB_RELEASE != "24.04" ]; then
        pip3 install --no-cache-dir \
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
    else
        apt-get update &&
            DEBIAN_FRONTEND=noninteractive apt-get install \
                -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                python3-autopep8 \
                cmake-format \
                flake8 \
                python3-pip-whl \
                python3-pipdeptree python3-sympy python3-pandas python3-tk python3-scipy \
                python3-matplotlib python3-bashate

    fi

    cd /
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
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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

    if [ $DISTRIB_RELEASE != "24.04" ]; then
        pip3 install --no-cache-dir Mosek
    fi

    # --- Install osqp
    cd /
    git clone --recurse-submodules --branch v0.6.3 https://github.com/osqp/osqp.git
    cd osqp &&
        mkdir build &&
        cd build &&
        cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make -j$(nproc) && make install
    cd /
    rm -rf /osqp

    # --- install just in time lua compiler
    cd /
    git clone https://luajit.org/git/luajit.git
    cd luajit
    make -j$(nproc) && make install PREFIX=/usr/
    cd /
    rm -rf /luajit

    # --- install ruckig
    cd /
    git clone https://github.com/pantor/ruckig.git
    cd ruckig
    mkdir build
    cd build
    cmake .. -DBUILD_CLOUD_CLIENT=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr
    make -j$(nproc) && make install
    cd /
    rm -rf ruckig

    # --- Install tidy to format xml files
    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            tidy \
            cscope \
            universal-ctags

    # --- Install rst formatter and linter

    if [ $DISTRIB_RELEASE = "24.04" ]; then
        pip3 install --no-cache-dir --user --break-system-packages rstcheck[sphinx] rstfmt
    else
        pip3 install --no-cache-dir rstcheck[sphinx] rstfmt
    fi

    # --- Install pygments  generic syntax highlighter

    if [ $DISTRIB_RELEASE = "24.04" ]; then
        pip3 install --no-cache-dir --user --break-system-packages pygments
    else
        pip3 install --no-cache-dir pygments
    fi

    # --- Install yamllint to lint yaml files

    if [ $DISTRIB_RELEASE = "24.04" ]; then
        pip3 install --no-cache-dir --user --break-system-packages yamllint
    else
        pip3 install --no-cache-dir yamllint
    fi

    # --- Install glogal tag finder
    cd /
    wget https://ftp.gnu.org/pub/gnu/global/global-6.6.13.tar.gz
    tar xzf global-6.6.13.tar.gz
    cd global-6.6.13
    ./configure --prefix=/usr
    make -j$(nproc)
    make install
    cd /
    rm -rf global-6.6.13

    rm -rf /usr/share/man/*
    rm -rf /usr/share/doc/*
    rm -rf /usr/share/local/*
    apt-get clean
    rm -rf /var/lib/apt/lists/*

}

main
