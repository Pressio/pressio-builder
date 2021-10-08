#!/bin/bash

function pressio_build_type(){
    CMAKELINE+="-D CMAKE_BUILD_TYPE:STRING=${MODEbuild} "
}

function pressio_cmake_verbose(){
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
}

function pressio_mpi_c_cxx_compilers(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_MPI:BOOL=ON "
    CMAKELINE+="-D CMAKE_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D CMAKE_CXX_COMPILER:FILEPATH=${CXX} "
}

function pressio_mpi_fortran_on(){
    CMAKELINE+="-D MPI_Fortran_COMPILER:FILEPATH=${F90} "
}

# serial compilers (if you pick serial you should not pick mpi)
function pressio_serial_c_cxx_compilers(){
    CMAKELINE+="-D CMAKE_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D CMAKE_CXX_COMPILER:FILEPATH=${CXX} "
}

# serial compilers (if you pick serial you should not pick mpi)
function pressio_serial_fortran_compiler(){
    CMAKELINE+="-D CMAKE_Fortran_COMPILER:FILEPATH=${FC} "
}

function pressio_tests_on(){
    CMAKELINE+="-D PRESSIO_ENABLE_TESTS:BOOL=ON "
}

function pressio_functional_small_tests_on(){
    CMAKELINE+="-D PRESSIO_ENABLE_FUNCTIONAL_SMALL_TESTS:BOOL=ON "
}

function pressio_functional_medium_tests_on(){
    CMAKELINE+="-D PRESSIO_ENABLE_FUNCTIONAL_MEDIUM_TESTS:BOOL=ON "
}

function pressio_functional_large_tests_on(){
    CMAKELINE+="-D PRESSIO_ENABLE_FUNCTIONAL_LARGE_TESTS:BOOL=ON "
}

function pressio_enable_debug_print(){
    CMAKELINE+="-D PRESSIO_ENABLE_DEBUG_PRINT=ON "
}

function pressio_blas_on(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_BLAS=ON "
}

function pressio_lapack_on(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_LAPACK=ON "
}

function pressio_openblaslapack(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_BLAS=ON "
    # note that BLAS_ROOT needs to be set by environemnt
    if [ -z ${BLAS_ROOT} ]; then
	echo "BLAS_ROOT needs to be set in the environment"
	exit 0
    fi
    #CMAKELINE+="-DBLAS_DIR=${BLAS_ROOT} "

    CMAKELINE+="-D PRESSIO_ENABLE_TPL_LAPACK=ON "
    # note that LAPACK_ROOT needs to be set by environemnt
    if [ -z ${LAPACK_ROOT} ]; then
	echo "LAPACK_ROOT needs to be set in the environment"
	exit 0
    fi
    #CMAKELINE+="-DLAPACK_DIR=${BLAS_ROOT} "
}

function pressio_enable_gtest(){
    CMAKELINE+="-D GTEST_ROOT=${GTESTPATH} "
}

function pressio_enable_eigen(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_EIGEN=ON "
    local LINE="${EIGENPATH};${EIGENPATH}/include/eigen3"
    CMAKELINE+="-D EIGEN_INCLUDE_DIR='${LINE}' "
}

function pressio_disable_eigen(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_EIGEN=OFF "
}

function pressio_enable_trilinos(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_TRILINOS=ON "
    CMAKELINE+="-D TRILINOS_ROOT=${TRILINOSPATH} "
    # # the following is equivalent to doing:
    # #-D TRILINOS_LIBRARY_DIRS="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    # local TRILLIBstiched="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    # CMAKELINE+="-D TRILINOS_LIB_DIR='${TRILLIBstiched}' "
}

function pressio_enable_kokkos(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_KOKKOS=ON "
    CMAKELINE+="-D KOKKOS_ROOT=${KOKKOSPATH} "
    CMAKELINE+="-D KOKKOS_KERNELS_ROOT=${KOKKOSKERNELSPATH} "
}

function pressio_enable_pybind11(){
    CMAKELINE+="-D PRESSIO_ENABLE_TPL_PYBIND11=ON "
    CMAKELINE+="-D PYBIND11_ROOT:PATH=${PYBIND11PATH} "
}









# function pressio_enable_omp(){
#     CMAKELINE+="-D pressio_ENABLE_OpenMP:BOOL=ON "
# }

# function pressio_enable_binutils(){
#     CMAKELINE+="-D TPL_ENABLE_BinUtils=ON "
# }

# function pressio_enable_mkl(){
#     CMAKELINE+="-D TPL_ENABLE_MKL=ON "
# }

# function pressio_add_dl_link(){
#     # the semic ; is needed beccause it builds a string
#     EXTRALINKFLAGS+=";dl"
# }

function pressio_enable_cxx_pedantic_errors(){
    CXXFLAGS+="-Werror=pedantic -pedantic-errors "
}

# function pressio_add_gfortran_cxx_flag(){
#     CXXFLAGS+="-gfortran "
# }

# function pressio_examples_on(){
#     CMAKELINE+="-D BUILD_EXAMPLES:BOOL=ON "
# }

# function pressio_link_type(){
#     local is_shared=ON
#     local link_search_static=OFF
#     if [[ ${LINKTYPE} == static ]]; then
# 	is_shared=OFF
# 	link_search_static=ON
#     fi
#     echo "is_shared = $is_shared"
#     echo "link_search_static = $link_search_static"
#     CMAKELINE+="-D BUILD_SHARED_LIBS:BOOL=${is_shared} "
#     # following lines cause issues for CEE, it seems we dont need them
#     #CMAKELINE+="-D pressio_LINK_SEARCH_START_STATIC=$link_search_static "
#     #CMAKELINE+="-D TPL_FIND_SHARED_LIBS=${is_shared} "
# }
