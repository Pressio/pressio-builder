#!/bin/bash

function default(){
    kokkos-kernels_always_needed
    kokkos-kernels_blas
    kokkos-kernels_lapack
    kokkos-kernels_compilers
    kokkos-kernels_tests_off
    kokkos-kernels_eti_basic
}
