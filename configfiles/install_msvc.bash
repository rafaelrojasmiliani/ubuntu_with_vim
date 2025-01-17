#!/bin/bash

main() {
    set -xeu

    echo apt-get update &&
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
            msitools winbind

    cd /
    git clone https://github.com/mstorsjo/msvc-wine.git
    cd /msvc-wine

    original_umask=$(umask)
    # Set umask to 0000 to create all filws with 666 by default

    umask 0000
    mkdir -p /opt/msvc
    ./vsdownload.py --dest /opt/msvc <<< "yes"
    ./install.sh /opt/msvc

    umask ${original_umask}

    rm -rf /msvc-wine

}

main
