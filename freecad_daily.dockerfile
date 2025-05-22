# This file tells docker what image must be created
# in order to be ahble to test this library
ARG BASEIMAGE
FROM ${BASEIMAGE}
SHELL ["bash", "-c"]

RUN set -x \
    && sudo add-apt-repository ppa:freecad-maintainers/freecad-daily \
    && sudo apt update \
    && sudo apt install freecad-daily
