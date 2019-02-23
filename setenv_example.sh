#!/bin/bash

MPIPATH=/Users/fnrizzi/tpl/openmpi/4.0.0/install_gcc650

# CC has to be set because this is what is used by scripts inside
export CC=${MPIPATH}/bin/mpicc

# CXX has to be set because this is what is used by scripts inside
export CXX=${MPIPATH}/bin/mpic++

# MPIRUNe has to be set because this is what is used by scripts inside
export MPIRUNe=${MPIPATH}/bin/mpirun
