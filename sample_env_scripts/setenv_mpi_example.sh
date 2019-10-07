#!/usr/bin/env bash

MPIPATH=/tpl/openmpi/4.0.0/install_gcc650

# CC is used by scripts inside
export CC=${MPIPATH}/bin/mpicc

# CXX is used by scripts inside
export CXX=${MPIPATH}/bin/mpic++

# FC is used by scripts inside
export FC=${MPIPATH}/bin/mpifort

# This is only used if you plan to run "ctest". If you DO not plan to use ctest,
# and run tests manually, then this is useless.
export MPIRUNe=${MPIPATH}/bin/mpirun
