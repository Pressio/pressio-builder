#!/bin/bash

SRC=/Users/fnrizzi/tpl/armadillo/armadillo-9.100.5
PFX=/Users/fnrizzi/tpl/armadillo/install_gcc640
CC=/opt/local/bin/gcc-mp-6
CXX=/opt/local/bin/g++-mp-6

cmake -D DETECT_HDF5:BOOL=FALSE\
      -D CMAKE_CXX_COMPILER:FILEPATH=${CXX} \
      -D CMAKE_C_COMPILER:FILEPATH=${CC} \
      -D CMAKE_INSTALL_PREFIX:PATH=${PFX} \
      ${SRC}


