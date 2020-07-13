#!/bin/bash

function default(){
    gtest_link_type
    gtest_verbose_makefile
    gtest_compilers
    CMAKELINE+="–D CMAKE_CXX_STANDARD=11 "

    # check if we are on mac, if so turn r_path
    if [[ $OSTYPE == *"darwin"* ]]; then
	echo "on mac: turning on r_path for gtest"
	gtest_mac_r_path
    fi
}
