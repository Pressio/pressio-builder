#!/bin/bash

function default(){
    # Note: the C compiler is not forgotten, it is NOT used by pybind11
    #CMAKELINE+="-D CMAKE_C_COMPILER:FILEPATH=${CC} "

    CMAKELINE+="-D CMAKE_CXX_COMPILER:FILEPATH=${CXX} "
    CMAKELINE+="-D CMAKE_BUILD_TYPE:STRING=${MODEbuild} "
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
    CMAKELINE+="-D PYBIND11_TEST:BOOL=FALSE "
}
