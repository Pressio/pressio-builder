#!/bin/bash

MPIPATH=/Users/fnrizzi/tpl/openmpi/4.0.0/install_gcc650

#export CC=/opt/local/bin/gcc-mp-6
#export CXX=/opt/local/bin/g++-mp-6

export CC=${MPIPATH}/bin/mpicc
export CXX=${MPIPATH}/bin/mpic++
export MPIRUNe=${MPIPATH}/bin/mpirun
