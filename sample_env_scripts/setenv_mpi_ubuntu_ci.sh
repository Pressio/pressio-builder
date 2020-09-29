#!/bin/bash

export BLAS_ROOT=/usr
export BLAS_LIBRARIES=blas
export LAPACK_ROOT=/usr
export LAPACK_LIBRARIES=openblas

export OPENBLAS_NUM_THREADS=1

MPIPATH=/usr
export CC=${MPIPATH}/bin/mpicc
export CXX=${MPIPATH}/bin/mpic++
export FC=${MPIPATH}/bin/mpifort
export F77=${MPIPATH}/bin/mpif77
export F90=${MPIPATH}/bin/mpif90

export MPIRUNe=${MPIPATH}/bin/mpirun
