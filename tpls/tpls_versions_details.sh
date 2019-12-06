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
GTESTGITURL=git@github.com:google/googletest.git
GTESTBRANCH=master

#----------
# trilinos
#----------
TRILINOSGITURL=git@github.com:trilinos/Trilinos.git
TRILINOSBRANCH=trilinos-release-12-18-branch

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
