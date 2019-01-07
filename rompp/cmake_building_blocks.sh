#!/bin/bash

general_options(){
    local is_shared=ON
    [[ ${BUILDlib} == static ]] && is_shared=OFF
    echo "is_shared = $is_shared"
    local link_search_static=OFF
    [[ ${BUILDlib} == static ]] && link_search_static=ON

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
    FLAGScombo="-fopenmp"
    CMAKELINE+="-D CMAKE_CXX_FLAGS=${FLAGScombo} "
}

mpi_fortran_on(){
    CMAKELINE+="-D rompp_ENABLE_Fortran:BOOL=ON "
    CMAKELINE+="-D MPI_Fortran_COMPILER:FILEPATH=${FCC} "
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
    #-D EIGEN_INCLUDE_DIRS:PATH=${EIGENPATH}
    EIGINC="${EIGENPATH};${EIGENPATH}/include/eigen3 "
    CMAKELINE+="-D EIGEN_INCLUDE_DIRS=${EIGINC} "
}

enable_trilinos(){
    CMAKELINE+="-D TPL_ENABLE_TRILINOS=ON "
    CMAKELINE+="-D TRILINOS_INCLUDE_DIRS:PATH=${TRILINOSPATH}/include "

    # the following is equivalent to doing:
    #-D TRILINOS_LIBRARY_DIRS="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    TRILLIBstiched="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib"
    CMAKELINE+="-D TRILINOS_LIBRARY_DIRS=${TRILLIBstiched} "
}

enable_gtest(){
    CMAKELINE+="-D TPL_ENABLE_GTEST=ON "
    CMAKELINE+="-D GTEST_INCLUDE_DIRS:PATH=${GTESTPATH}/include "

    # the following is equivalent to doing:
    # -D GTEST_LIBRARY_DIRS="${GTESTPATH}/lib64;${GTESTPATH}/lib"
    GTLIBstiched="${GTESTPATH}/lib;${GTESTPATH}/lib64"
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
    #CMAKELINE+="-D DEBUG_PRINT::BOOL=ON "
}

all_packages(){
    CMAKELINE+="-D rompp_ENABLE_ALL_PACKAGES:BOOL=ON "
}
