#!/bin/bash

general_options(){
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
    CMAKELINE+="-D TPL_FIND_SHARED_LIBS=${is_shared} "
    CMAKELINE+="-D rompp_LINK_SEARCH_START_STATIC=$link_search_static "
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
    CMAKELINE+="-D rompp_ENABLE_CXX11:BOOL=ON "
    CMAKELINE+="-D rompp_ENABLE_SHADOW_WARNINGS:BOOL=OFF "
}

mpi_compiler_options(){
    CMAKELINE+="-D TPL_ENABLE_MPI:BOOL=ON "
    CMAKELINE+="-D MPI_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D MPI_CXX_COMPILER:FILEPATH=${CXX} "
    CMAKELINE+="-D MPI_EXEC:FILEPATH=${MPIRUNe} "
    CMAKELINE+="-D MPI_USE_COMPILER_WRAPPERS:BOOL=ON "
}

with_omp_flag(){
    local FLAGScombo="-fopenmp"
    CMAKELINE+="-D CMAKE_CXX_FLAGS=${FLAGScombo} "
}

with_omp_gfortran_flag(){
    local FLAGScombo="-fopenmp -gfortran"
    CMAKELINE+="-D CMAKE_CXX_FLAGS=${FLAGScombo} "
}

mpi_fortran_on(){
    CMAKELINE+="-D rompp_ENABLE_Fortran:BOOL=ON "
    CMAKELINE+="-D MPI_Fortran_COMPILER:FILEPATH=${F90} "
}

mpi_fortran_off(){
    CMAKELINE+="-D rompp_ENABLE_Fortran:BOOL=OFF "
}

tests_off(){
    CMAKELINE+="-D rompp_ENABLE_TESTS:BOOL=OFF "
}

tests_on(){
    CMAKELINE+="-D rompp_ENABLE_TESTS:BOOL=ON "
}

examples_off(){
    CMAKELINE+="-D rompp_ENABLE_EXAMPLES:BOOL=OFF "
}

enable_eigen(){
    CMAKELINE+="-D TPL_ENABLE_EIGEN=ON "
    # the following is equivalent to doing:
    #-D EIGEN_INCLUDE_DIRS:PATH="${EIGENPATH}; ${EIGENPATH}/include/eigen3"
    local EIGINC="${EIGENPATH};${EIGENPATH}/include/eigen3 "
    CMAKELINE+="-D EIGEN_INCLUDE_DIRS=${EIGINC} "
}

enable_trilinos(){
    CMAKELINE+="-D TPL_ENABLE_TRILINOS=ON "
    CMAKELINE+="-D TRILINOS_INCLUDE_DIRS:PATH=${TRILINOSPATH}/include "

    # the following is equivalent to doing:
    #-D TRILINOS_LIBRARY_DIRS="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    local TRILLIBstiched="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    CMAKELINE+="-D TRILINOS_LIBRARY_DIRS=${TRILLIBstiched} "
}

cee_sparc_blas_options(){
    CMAKELINE+="-D TPL_ENABLE_BLAS=ON "

    # note that CBLAS_ROOT is set by environemnt on cee using the module
    local BLASlibstich="${CBLAS_ROOT}/mkl/lib/intel64;${CBLAS_ROOT}/lib/intel64"
    CMAKELINE+="-D BLAS_LIBRARY_DIRS:PATH=${BLASlibstich} "

    local BLASNAMES="mkl_intel_lp64;mkl_intel_thread;mkl_core;iomp5"
    CMAKELINE+="-D BLAS_LIBRARY_NAMES:STRING=${BLASNAMES} "
}

cee_sparc_lapack_options(){
    CMAKELINE+="-D TPL_ENABLE_LAPACK=ON "

    # note that CBLAS_ROOT is set by environemnt on cee using the module
    local LAPACKlibstich="${CBLAS_ROOT}/mkl/lib/intel64;${CBLAS_ROOT}/lib/intel64"
    CMAKELINE+="-D LAPACK_LIBRARY_DIRS:PATH=${LAPACKlibstich} "

    local LAPACKNAMES="mkl_intel_lp64;mkl_intel_thread;mkl_core;iomp5"
    CMAKELINE+="-D LAPACK_LIBRARY_NAMES:STRING=${LAPACKNAMES} "
}

enable_gtest(){
    CMAKELINE+="-D TPL_ENABLE_GTEST=ON "
    CMAKELINE+="-D GTEST_INCLUDE_DIRS:PATH=${GTESTPATH}/include "

    # the following is equivalent to doing:
    # -D GTEST_LIBRARY_DIRS="${GTESTPATH}/lib64;${GTESTPATH}/lib"
    local GTLIBstiched="${GTESTPATH}/lib;${GTESTPATH}/lib64"
    CMAKELINE+="-D GTEST_LIBRARY_DIRS=${GTLIBstiched} "
}

rompp_packages(){
    CMAKELINE+="-D rompp_ENABLE_ALL_PACKAGES:BOOL=OFF "
    CMAKELINE+="-D rompp_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF "

    CMAKELINE+="-D rompp_ENABLE_core:BOOL=${buildCORE} "
    CMAKELINE+="-D rompp_ENABLE_qr:BOOL=${buildQR} "
    CMAKELINE+="-D rompp_ENABLE_solvers:BOOL=${buildSOLVERS} "
    CMAKELINE+="-D rompp_ENABLE_svd:BOOL=${buildSVD} "
    CMAKELINE+="-D rompp_ENABLE_ode:BOOL=${buildODE} "
    CMAKELINE+="-D rompp_ENABLE_rom:BOOL=${buildROM} "
}

enable_debug_print(){
    CMAKELINE+="-D DEBUG_PRINT::BOOL=ON "
}

all_packages(){
    CMAKELINE+="-D rompp_ENABLE_ALL_PACKAGES:BOOL=ON "
}
