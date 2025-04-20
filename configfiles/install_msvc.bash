#!/bin/bash

main() {

    set -xeu

    apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            msitools winbind wine-binfmt winetricks \
            wine64 python3 msitools ca-certificates winbind git wget \
            vim \
            cmake \
            vim-gtk3 \
            lsb-release \
            cmake-curses-gui cmake-qt-gui

    cd /
    git clone https://github.com/mstorsjo/msvc-wine.git
    cd /msvc-wine

    original_umask=$(umask)
    # Set umask to 0000 to create all filws with 666 by default

    umask 0000
    mkdir -p /opt/msvc
    ./vsdownload.py --dest /opt/msvc <<<"yes"
    ./install.sh /opt/msvc
    cd ..
    rm -rf /msvc-wine

    # set wine prefix where Wine simulates the Windows environment
    mkdir /opt/wine
    export WINEPREFIX=/opt/wine
    export WINEARCH=win64
    cat <<EOF >/opt/msvc/toolchain.cmake
set(CMAKE_SYSTEM_NAME "Windows")
set(CMAKE_HOST_WIN32 true)

set(PYTHON_EXE "/usr/bin/python3")

set(CMAKE_C_COMPILER /opt/msvc/bin/x64/cl)
set(CMAKE_CXX_COMPILER /opt/msvc/bin/x64/cl)

set(CMAKE_NINJA_FORCE_RESPONSE_FILE
    1
    CACHE INTERNAL "" FORCE)

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)

set(CMAKE_EXE_LINKER_FLAGS /MANIFEST:NO)
set(CMAKE_SHARED_LINKER_FLAGS /MANIFEST:NO)
EOF

    umask ${original_umask}
    echo 'export PATH=/opt/msvc/bin/x64/:$PATH' >>/etc/bash.bashrc
    echo "export WINEPREFIX=/opt/wine" >>/etc/bash.bashrc
    echo "export WINEARCH=win64" >>/etc/bash.bashrc

}

main
