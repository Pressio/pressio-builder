#!/bin/bash

function kokkos_always_needed(){
    local is_shared=ON
    local link_search_static=OFF
    if [[ ${LINKTYPE} == static ]]; then
	is_shared=OFF
	link_search_static=ON
    fi
    echo "is_shared = $is_shared"
    echo "link_search_static = $link_search_static"

    CMAKELINE+="-D CMAKE_BUILD_TYPE:STRING=${MODEbuild} "
    #CMAKELINE+="-D BUILD_SHARED_LIBS:BOOL=${is_shared} "
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
}

function kokkos_compilers(){
    CMAKELINE+="-D CMAKE_CXX_COMPILER=${CC} "
}

function kokkos_tests_off(){
    CMAKELINE+="-D Kokkos_ENABLE_TESTS:BOOL=OFF "
}

function kokkos_serial(){
    CMAKELINE+="-D Kokkos_ENABLE_SERIAL=ON "
    CMAKELINE+="-D Kokkos_ENABLE_OPENMP=OFF "
}
