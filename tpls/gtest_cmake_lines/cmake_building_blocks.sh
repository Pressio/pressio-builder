#!/bin/bash

function gtest_always_needed(){
    local is_shared=ON
    [[ ${LINKTYPE} == static ]] && is_shared=OFF
    echo "is_shared = $is_shared"

    CMAKELINE+="-D BUILD_SHARED_LIBS:BOOL=${is_shared} "
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
}

function gtest_compilers(){
    CMAKELINE+="-D CMAKE_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D CMAKE_CXX_COMPILER:FILEPATH=${CXX} "
}

function gtest_mac_r_path(){
    #local is_mac=OFF
    #[[ ${ARCH} == mac ]] && is_mac=ON
    #echo "is_mac = $is_mac"
    CMAKELINE+="-D CMAKE_MACOSX_RPATH:BOOL=ON "
}
