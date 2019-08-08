#!/bin/bash

default(){
    always_needed
    compilers

    # check if we are on mac, if so turn r_path
    if [[ $OSTYPE == *"darwin"* ]]; then
	echo "on mac: turning on r_path for gtest"
	mac_r_path
    fi
    echo CMAKELINE
}
