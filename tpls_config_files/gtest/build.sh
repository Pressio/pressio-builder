#!/bin/bash

src=/Users/fnrizzi/tpl/gtest/googletest
PFX=/Users/fnrizzi/tpl/gtest/install
CC=/opt/local/bin/gcc-mp-6
CXX=/opt/local/bin/g++-mp-6


cmake -D BUILD_SHARED_LIBS=ON \
      -D CMAKE_MACOSX_RPATH:BOOL=ON \
      -D CMAKE_CXX_COMPILER:FILEPATH=${CXX} \
      -D CMAKE_C_COMPILER:FILEPATH=${CC} \
      -D CMAKE_INSTALL_PREFIX:PATH=${pfx} \
      ${src}



