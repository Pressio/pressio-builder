#!/usr/bin/env bash

#----------
# eigen
#----------
EIGENVERSION=3.3.7
EIGENTARURL=https://gitlab.com/libeigen/eigen/-/archive/${EIGENVERSION}/eigen-${EIGENVERSION}.tar.gz
EIGENUNPACKEDDIRNAME=eigen-${EIGENVERSION}

#----------
# gtest
#----------
GTESTGITURL=https://github.com/google/googletest.git
GTESTBRANCH=master

#----------
# trilinos
#----------
TRILINOSGITURL=https://github.com/trilinos/Trilinos.git
TRILINOSBRANCH=master
TRILINOSCOMMITHASH=9fec35276d846a667bc668ff4cbdfd8be0dfea08

#----------
# kokkos core and kernels
#----------
KOKKOSURL=git@github.com:kokkos/kokkos.git
KOKKOSKERURL=git@github.com:kokkos/kokkos-kernels.git
KOKKOSTAG=3.1.00

#----------
# pybind11
#----------
PYBINDGITURL=git@github.com:Pressio/pybind11.git
PYBINDBRANCH=pressio_v2.6

#----------
# cmake
#----------
# needed minimum cmake version
CMAKEVERSIONMIN=3.11.0
