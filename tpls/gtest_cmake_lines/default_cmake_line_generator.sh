#!/bin/bash

function default(){
    gtest_always_needed
    gtest_compilers

    # check if we are on mac, if so turn r_path
    if [[ $OSTYPE == *"darwin"* ]]; then
	echo "on mac: turning on r_path for gtest"
	gtest_mac_r_path
    fi
}