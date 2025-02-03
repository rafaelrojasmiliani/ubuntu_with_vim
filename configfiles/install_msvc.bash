#!/bin/bash

main() {
    set -xeu

    echo apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            msitools winbind wine-binfmt winetricks

    cd /
    git clone https://github.com/mstorsjo/msvc-wine.git
    cd /msvc-wine

    original_umask=$(umask)
    # Set umask to 0000 to create all filws with 666 by default

    umask 0000
    mkdir -p /opt/msvc
    ./vsdownload.py --dest /opt/msvc <<<"yes"
    ./install.sh /opt/msvc

    rm -rf /msvc-wine

    # set wine prefix where Wine simulates the Windows environment
    mkdir /opt/wine
    export WINEPREFIX=/opt/wine
    export WINEARCH=win64
    wineboot --init
    cat <<EOF >/opt/msvc/toolchain.cmake
set(CMAKE_SYSTEM_NAME "Windows")
set(CMAKE_HOST_WIN32 true)

set(PYTHON_EXE "/usr/bin/python3")

set(MSVC_WINE_PATH "/opt/msvc") # set the path here
set(CMAKE_C_COMPILER ${MSVC_WINE_PATH}/bin/x64/cl)
set(CMAKE_CXX_COMPILER ${MSVC_WINE_PATH}/bin/x64/cl)

set(CMAKE_NINJA_FORCE_RESPONSE_FILE
    1
    CACHE INTERNAL "" FORCE)

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)

set(CMAKE_EXE_LINKER_FLAGS /MANIFEST:NO)
set(CMAKE_SHARED_LINKER_FLAGS /MANIFEST:NO)
EOF

    umask ${original_umask}
    echo "export PATH=/opt/msvc/bin/x64/:$PATH" >>/etc/bash.bashrc
    echo "export WINEPREFIX=/opt/wine" >>/etc/bash.bashrc
    echo "export WINEARCH=win32" >>/etc/bash.bashrc

}

main
