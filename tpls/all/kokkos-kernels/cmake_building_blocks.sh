#!/bin/bash

function kokkos-kernels_always_needed(){
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

function kokkos-kernels_compilers(){
    CMAKELINE+="-D CMAKE_CXX_COMPILER=${CC} "
}

function kokkos-kernels_tests_off(){
    CMAKELINE+="-D KokkosKernels_ENABLE_TESTS:BOOL=OFF "
}

function kokkos-kernels_blas(){
    CMAKELINE+="-D KokkosKernels_ENABLE_TPL_BLAS=On "
    CMAKELINE+="-D KokkosKernels_BLAS_ROOT=${BLAS_ROOT} "
    CMAKELINE+="-D BLAS_LIBRARIES=${BLAS_LIBRARIES} "
}

function kokkos-kernels_lapack(){
    CMAKELINE+="-D KokkosKernels_ENABLE_TPL_LAPACK=On "
    CMAKELINE+="-D KokkosKernels_LAPACK_ROOT=${LAPACK_ROOT} "
    CMAKELINE+="-D LAPACK_LIBRARIES=${LAPACK_LIBRARIES} "
}

function kokkos-kernels_eti_basic(){
    CMAKELINE+="-D KokkosKernels_INST_DOUBLE=On "
    CMAKELINE+="-D KokkosKernels_INST_LAYOUTRIGHT=On "
    CMAKELINE+="-D KokkosKernels_INST_LAYOUTLEFT=On "
    CMAKELINE+="-D KokkosKernels_INST_ORDINAL_INT=On "
    CMAKELINE+="-D KokkosKernels_INST_ORDINAL_INT64_T=Off "
    CMAKELINE+="-D KokkosKernels_INST_OFFSET_INT=On "
    CMAKELINE+="-D KokkosKernels_INST_OFFSET_SIZE_T=Off "
}
