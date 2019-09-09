#!/bin/bash

function pressio_tut_always_needed(){
    CMAKELINE+="-D CMAKE_BUILD_TYPE:STRING=${MODEbuild} "
}

function pressio_tut_cmake_verbose(){
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
}

function pressio_tut_serial_c_cxx_compilers(){
    CMAKELINE+="-D CMAKE_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D CMAKE_CXX_COMPILER:FILEPATH=${CXX} "
}

function pressio_tut_serial_fortran_compiler(){
    CMAKELINE+="-D CMAKE_Fortran_COMPILER:FILEPATH=${FC} "
}

function pressio_tut_eigen(){
    CMAKELINE+="-D EIGEN_INCLUDE_DIR=${EIGENPATH}/include/eigen3 "
}

function pressio_tut_pressio(){
    CMAKELINE+="-D PRESSIO_INCLUDE_DIR=${PRESSIOPATH}/include "
}
