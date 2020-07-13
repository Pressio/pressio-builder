#!/usr/bin/env bash

#----------
# eigen
#----------
EIGENVERSION=3.3.7
EIGENURL=http://bitbucket.org/eigen/eigen/get/${EIGENVERSION}
# specify the name of the unpacked dir when unpacking the tar
# make sure you update this if updating the version above
EIGENUNPACKEDDIRNAME=eigen-eigen-323c052e1731

#----------
# gtest
#----------
GTESTGITURL=https://github.com/google/googletest.git
GTESTBRANCH=master

#----------
# trilinos
#----------
TRILINOSGITURL=git@github.com:trilinos/Trilinos.git
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
PYBINDBRANCH=origin/v2.3

#----------
# cmake
#----------
# needed minimum cmake version
CMAKEVERSIONMIN=3.11.0
