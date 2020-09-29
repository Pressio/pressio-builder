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
TRILINOSCOMMITHASH=d5abc894f1052682c4933b9b6951d904e74aa7fe

#----------
# kokkos core and kernels
#----------
KOKKOSURL=git@github.com:kokkos/kokkos.git
KOKKOSKERURL=git@github.com:kokkos/kokkos-kernels.git
KOKKOSTAG=3.1.00

#----------
# pybind11
#----------
PYBINDGITURL=git@github.com:pybind/pybind11.git
PYBINDBRANCH=origin/v2.5

#----------
# cmake
#----------
# needed minimum cmake version
CMAKEVERSIONMIN=3.11.0
