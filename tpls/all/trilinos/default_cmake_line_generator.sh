#!/bin/bash

function default(){
    trilinos_build_type
    trilinos_link_type
    trilinos_verbose_makefile_on
    trilinos_mpi_c_cxx_compilers
    trilinos_mpi_fortran_on
    trilinos_tests_off
    trilinos_examples_off
    trilinos_blas_on
    trilinos_lapack_on
    trilinos_kokkos_serial
    trilinos_packages_for_pressio
}

function frizzimac(){
    trilinos_build_type
    trilinos_link_type
    trilinos_verbose_makefile_on
    trilinos_mpi_c_cxx_compilers
    trilinos_mpi_fortran_on
    trilinos_tests_off
    trilinos_examples_off
    trilinos_openblaslapack
    trilinos_kokkos_serial
    trilinos_packages_for_pressio
}
