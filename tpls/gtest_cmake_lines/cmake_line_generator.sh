#!/bin/bash

default(){
    always_needed
    compilers

    # check if we are on mac, if so turn r_path
    if [[ "$OSTYPE" == "darwin"* ]]; then
	mac_r_path
    fi
    echo CMAKELINE
}
