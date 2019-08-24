#!/bin/bash

# this is always needed, regardless of where we build
# so don't change the name and always include it when customizing a build
function always_needed(){
    local is_shared=ON
    local link_search_static=OFF
    if [[ ${MODElib} == static ]]; then
	is_shared=OFF
	link_search_static=ON
    fi
    echo "is_shared = $is_shared"
    echo "link_search_static = $link_search_static"

    CMAKELINE+="-D CMAKE_BUILD_TYPE:STRING=${MODEbuild} "
    CMAKELINE+="-D BUILD_SHARED_LIBS:BOOL=${is_shared} "
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
    CMAKELINE+="-D pressio_ENABLE_CXX11:BOOL=ON "
    CMAKELINE+="-D pressio_ENABLE_SHADOW_WARNINGS:BOOL=OFF "

    # following lines cause issues for CEE, and are also not used
    # e.g. by SPARC trilinos scripts, it seems we dont need them
    #CMAKELINE+="-D pressio_LINK_SEARCH_START_STATIC=$link_search_static "
    #CMAKELINE+="-D TPL_FIND_SHARED_LIBS=${is_shared} "
}

function openblas(){
    CMAKELINE+="-D TPL_ENABLE_BLAS=ON "
    # note that BLAS_ROOT needs to be set by environemnt
    if [ -z ${BLAS_ROOT} ]; then
	echo "BLAS_ROOT needs to be set in the environment"
	exit 0
    fi
    CMAKELINE+="-D BLAS_LIBRARY_DIRS:PATH='${BLAS_ROOT}/lib' "
    CMAKELINE+="-D BLAS_LIBRARY_NAMES:STRING='openblas' "
}

function openblaslapack(){
    CMAKELINE+="-D TPL_ENABLE_LAPACK=ON "
    # note that LAPACK_ROOT needs to be set by environemnt
    if [ -z ${LAPACK_ROOT} ]; then
	echo "LAPACK_ROOT needs to be set in the environment"
	exit 0
    fi
    CMAKELINE+="-D LAPACK_LIBRARY_DIRS:PATH='${LAPACK_ROOT}/lib' "
    CMAKELINE+="-D LAPACK_LIBRARY_NAMES:STRING='openblas' "
}

# mpi compilers
function mpi_c_cxx_compilers(){
    CMAKELINE+="-D TPL_ENABLE_MPI:BOOL=ON "
    CMAKELINE+="-D MPI_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D MPI_CXX_COMPILER:FILEPATH=${CXX} "
    CMAKELINE+="-D MPI_EXEC:FILEPATH=${MPIRUNe} "
    CMAKELINE+="-D MPI_USE_COMPILER_WRAPPERS:BOOL=ON "
}

function mpi_fortran_on(){
    CMAKELINE+="-D pressio_ENABLE_Fortran:BOOL=ON "
    CMAKELINE+="-D MPI_Fortran_COMPILER:FILEPATH=${F90} "
}

# serial compilers (if you pick serial you should not pick mpi)
function serial_c_cxx_compilers(){
    CMAKELINE+="-D CMAKE_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D CMAKE_CXX_COMPILER:FILEPATH=${CXX} "
}

function fortran_off(){
    CMAKELINE+="-D pressio_ENABLE_Fortran:BOOL=OFF "
}

function add_dl_link(){
    # the semic ; is needed beccause it builds a string
    EXTRALINKFLAGS+=";dl"
}

function add_omp_cxx_flag(){
    CXXFLAGS+="-fopenmp "
}

function add_gfortran_cxx_flag(){
    CXXFLAGS+="-gfortran "
}

function tests_off(){
    CMAKELINE+="-D pressio_ENABLE_TESTS:BOOL=OFF "
}
function tests_on(){
    CMAKELINE+="-D pressio_ENABLE_TESTS:BOOL=ON "
}
function examples_off(){
    CMAKELINE+="-D pressio_ENABLE_EXAMPLES:BOOL=OFF "
}
function examples_on(){
    CMAKELINE+="-D pressio_ENABLE_EXAMPLES:BOOL=ON "
}
function enable_binutils(){
    CMAKELINE+="-D TPL_ENABLE_BinUtils=ON "
}

function enable_mkl(){
    CMAKELINE+="-D TPL_ENABLE_MKL=ON "
}

function enable_eigen(){
    CMAKELINE+="-D TPL_ENABLE_EIGEN=ON "
    local LINE="${EIGENPATH};${EIGENPATH}/include/eigen3"
    CMAKELINE+="-D EIGEN_INCLUDE_DIRS='${LINE}' "
}

function enable_pybind11(){
    CMAKELINE+="-D TPL_ENABLE_PYBIND11=ON "
    CMAKELINE+="-D PYBIND11_INCLUDE_DIRS:PATH=${PYBIND11PATH}/include "
}

function enable_kokkos(){
    CMAKELINE+="-D TPL_ENABLE_KOKKOS=ON "
    CMAKELINE+="-D KOKKOS_INCLUDE_DIRS:PATH=${KOKKOSPATH}/include "

    # the following is equivalent to doing:
    #-D KOKKOS_LIBRARY_DIRS="${KOKKOSPATH}/lib64;${KOKKOSPATH}/lib"
    local stiched="${KOKKOSPATH}/lib64;${KOKKOSPATH}/lib"
    CMAKELINE+="-D KOKKOS_LIBRARY_DIRS='${stiched}' "
}

function enable_trilinos(){
    CMAKELINE+="-D TPL_ENABLE_TRILINOS=ON "
    CMAKELINE+="-D TRILINOS_INCLUDE_DIRS:PATH=${TRILINOSPATH}/include "

    # the following is equivalent to doing:
    #-D TRILINOS_LIBRARY_DIRS="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    local TRILLIBstiched="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    CMAKELINE+="-D TRILINOS_LIBRARY_DIRS='${TRILLIBstiched}' "
}

function cee_sparc_blas(){
    CMAKELINE+="-D TPL_ENABLE_BLAS=ON "

    # note that CBLAS_ROOT is set by environemnt on cee using the module
    local BLASlibstich="${CBLAS_ROOT}/mkl/lib/intel64;${CBLAS_ROOT}/lib/intel64"
    CMAKELINE+="-D BLAS_LIBRARY_DIRS:PATH='${BLASlibstich}' "

    local BLASNAMES="mkl_intel_lp64;mkl_intel_thread;mkl_core;iomp5"
    CMAKELINE+="-D BLAS_LIBRARY_NAMES:STRING='${BLASNAMES}' "
}

function cee_sparc_lapack(){
    CMAKELINE+="-D TPL_ENABLE_LAPACK=ON "

    # note that CBLAS_ROOT is set by environemnt on cee using the module
    local LAPACKlibstich="${CBLAS_ROOT}/mkl/lib/intel64;${CBLAS_ROOT}/lib/intel64"
    CMAKELINE+="-D LAPACK_LIBRARY_DIRS:PATH='${LAPACKlibstich}' "

    local LAPACKNAMES="mkl_intel_lp64;mkl_intel_thread;mkl_core;iomp5"
    CMAKELINE+="-D LAPACK_LIBRARY_NAMES:STRING='${LAPACKNAMES}' "
}

function enable_gtest(){
    CMAKELINE+="-D TPL_ENABLE_GTEST=ON "
    CMAKELINE+="-D GTEST_INCLUDE_DIRS:PATH=${GTESTPATH}/include "

    local GTLIBstiched="${GTESTPATH}/lib;${GTESTPATH}/lib64"
    CMAKELINE+="-D GTEST_LIBRARY_DIRS='${GTLIBstiched}' "
}

# this should not change regardless of where we build because
# it is driven by the list of packages passed to the main build file
function pressio_packages(){
    CMAKELINE+="-D pressio_ENABLE_ALL_PACKAGES:BOOL=OFF "
    CMAKELINE+="-D pressio_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF "
    CMAKELINE+="-D pressio_ENABLE_mpl:BOOL=${buildMPL} "
    CMAKELINE+="-D pressio_ENABLE_utils:BOOL=${buildUTILS} "
    CMAKELINE+="-D pressio_ENABLE_containers:BOOL=${buildCONTAINERS} "
    CMAKELINE+="-D pressio_ENABLE_qr:BOOL=${buildQR} "
    CMAKELINE+="-D pressio_ENABLE_solvers:BOOL=${buildSOLVERS} "
    CMAKELINE+="-D pressio_ENABLE_svd:BOOL=${buildSVD} "
    CMAKELINE+="-D pressio_ENABLE_ode:BOOL=${buildODE} "
    CMAKELINE+="-D pressio_ENABLE_rom:BOOL=${buildROM} "
    CMAKELINE+="-D pressio_ENABLE_apps:BOOL=${buildAPPS} "
}

function enable_debug_print(){
    CMAKELINE+="-D DEBUG_PRINT::BOOL=ON "
}

function all_packages(){
    CMAKELINE+="-D pressio_ENABLE_ALL_PACKAGES:BOOL=ON "
}
