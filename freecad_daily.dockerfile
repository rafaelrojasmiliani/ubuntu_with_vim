# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
FROM ${BASEIMAGE}
SHELL ["/usr/bin/bash", "-c"]
# fix - error: externally-managed-environment
ENV PIP_BREAK_SYSTEM_PACKAGES 1

RUN set -xeu \
    echo -ne '\n' | add-apt-repository ppa:freecad-maintainers/freecad-daily \
    && apt-get update \
       && DEBIAN_FRONTEND=noninteractive apt-get install \
       -y --no-install-recommends -o \
       Dpkg::Options::="--force-confnew" freecad-daily \
    && apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* \
    && chmod 777 /usr/local/lib/python3.12/dist-packages \
    && chmod 777 /var/cache/apt/archives/ \
    && chmod 777 /var/lib/dpkg/

RUN mkdir -p /opt/miniconda && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda/miniconda.sh && \
    bash /opt/miniconda/miniconda.sh -b -u -p /opt/miniconda && \
    rm /opt/miniconda/miniconda.sh && \
    bash /opt/miniconda/bin/activate && \
    conda init --all && \
    conda config --add channels conda-forge && \
    conda create -n freecad_1_0_312 freecad=1.0.0=py312h0c3bf70_4 python=3.12 && \
    conda activate freecad_1_0_312 && \
    conda install numpy pandas matplotlib requests qt6-wayland pycollada && \
     apt-get autoclean -y && \
     apt-get autoremove -y && \
     rm -rf /var/lib/apt/lists/*
