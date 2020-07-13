#!/usr/bin/env bash

export CC=/opt/local/bin/gcc-mp-6
export CXX=/opt/local/bin/g++-mp-6
export FC=/opt/local/bin/gfortran-mp-6

# BLAS AND LAPACK are required for: trilinos, Kokkos-kernels
export BLAS_ROOT=/opt/local
export BLAS_LIBRARIES=openblas
export LAPACK_ROOT=/opt/local
export LAPACK_LIBRARIES=openblas
