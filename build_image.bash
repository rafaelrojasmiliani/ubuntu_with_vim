#!/usr/bin/env bash

main(){
    docker build -t "ubuntu_vim" -f ./ubuntu.dockerfile .
}

main

