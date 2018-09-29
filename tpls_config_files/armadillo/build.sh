#!/bin/bash

PFX=/Users/fnrizzi/tpl/armadillo/install_gcc640
CC=/opt/local/bin/gcc-mp-6
CXX=/opt/local/bin/g++-mp-6

cmake . \
      -D CMAKE_CXX_COMPILER:FILEPATH=${CXX} \
      -D CMAKE_C_COMPILER:FILEPATH=${CC} \
      -D CMAKE_INSTALL_PREFIX:PATH=${PFX}


