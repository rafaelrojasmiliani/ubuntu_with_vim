ARG BASEIMAGE
FROM ${BASEIMAGE}
SHELL ["bash", "-c"]

RUN set -ex && \
    apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install \
            -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
    lutris \
    wine \
    winbind \
    xvfb \
    x11-utils \
    x11-xserver-utils \
    pulseaudio \
    dbus-x11 \
    wget \
    git \
    libgl1-mesa-dri \
    mesa-utils \
    libvulkan1 \
    nvidia-utils-550
