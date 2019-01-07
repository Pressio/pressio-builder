#!/bin/bash

for_mac(){
    # this should work on any mac
    general_options
    mac_r_path
    compiler_options

    echo CMAKELINE
}

for_linux(){
    # this should work on any linux
    general_options
    compiler_options

    echo CMAKELINE
}

default(){
    for_linux
    echo CMAKELINE
}
