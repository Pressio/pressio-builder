#!/usr/bin/env bash

MPIPATH=/tpl/openmpi/4.0.0/install_gcc650

# CC is used by scripts inside
export CC=${MPIPATH}/bin/mpicc

# CXX is used by scripts inside
export CXX=${MPIPATH}/bin/mpic++

# FC is used by scripts inside
export FC=${MPIPATH}/bin/mpifort

# MPIRUN executable
export MPIRUNexe=${MPIPATH}/bin/mpirun

# BLAS AND LAPACK required for: trilinos, Kokkos-kernels
export BLAS_ROOT=/opt/local
export BLAS_LIBRARIES=openblas
export LAPACK_ROOT=/opt/local
export LAPACK_LIBRARIES=openblas
