#!/bin/bash

for_mac(){
    # this should work on any mac
    always_needed
    mac_r_path
    compilers

    echo CMAKELINE
}

for_linux(){
    # this should work on any linux
    always_needed
    compilers

    echo CMAKELINE
}

default(){
    for_linux
    echo CMAKELINE
}
