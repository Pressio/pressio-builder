#!/bin/bash

# source the shared global vars
source ../shared_global_vars.sh

# THISDIR will always contain the folder we start from
THISDIR=$PWD

# array storing tpl names
declare -a tpl_names=(gtest eigen trilinos)

EIGENCONFIGDIR=${THISDIR}/config_files
GTESTCONFIGDIR=${THISDIR}/config_files
TRILINOSCONFIGDIR=${THISDIR}/config_files/trilinos

# array storing tpl script names
declare -a tpl_scripts=(build_gtest build_eigen	build_trilinos_mpi_kokkos_omp)

# store the working dir
ARCH=

# store the working dir
WORKDIR=

# bool to wipe existing content of target directory
WIPEEXISTING=ON

# build mode: DEBUG/RELEASE
MODEbuild=DEBUG

# build/link shared or static lib
MODElib=shared

# env script
SETENVscript=

print_global_vars(){
    print_shared_global_vars

    echo "target tpls    = ${tpl_names[@]}"
    echo "target scripts = ${tpl_scripts[@]}"
}
