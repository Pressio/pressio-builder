#!/bin/bash

always_needed(){
    local is_shared=ON
    [[ ${MODElib} == static ]] && is_shared=OFF
    echo "is_shared = $is_shared"

    CMAKELINE+="-D BUILD_SHARED_LIBS:BOOL=${is_shared} "
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
}

compilers(){
    CMAKELINE+="-D CMAKE_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D CMAKE_CXX_COMPILER:FILEPATH=${CXX} "
}

mac_r_path(){
    #local is_mac=OFF
    #[[ ${ARCH} == mac ]] && is_mac=ON
    #echo "is_mac = $is_mac"
    CMAKELINE+="-D CMAKE_MACOSX_RPATH:BOOL=ON "
}
