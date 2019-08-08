#!/bin/bash

# source the shared global vars
source ../shared_global_vars.sh

# array storing packages
declare -a pkg_names=(core)

# path to dir where eigen is installed
EIGENPATH=
# path to dir where gtest is installed
GTESTPATH=
# path to dir where trilinos is installed
TRILINOSPATH=
# path to dir where Kokkos is installed
KOKKOSPATH=
# path to dir where pybind11 is installed
PYBIND11PATH=
# path to dir where all tpls are installed
# structure must follow what main_tpls.sh does
ALLTPLSPATH=

# pressio git repo src
PRESSIOSRC=

# name of the cmake configuring line
CMAKELINEGEN=

# n to use for parallelizing make
njmake=6

print_global_vars(){
    print_shared_global_vars
    echo "pkg_names      = ${pkg_names[@]}"
    echo "EIGENPATH      = $EIGENPATH"
    echo "GTESTPATH      = $GTESTPATH"
    echo "TRILINOSPATH   = $TRILINOSPATH"
    echo "KOKKOSPATH	 = $KOKKOSPATH"
    echo "PYBIND11PATH   = $PYBIND11PATH"
    echo "ALLTPLSPATH    = $ALLTPLSPATH"
    echo "ROMPPSRC       = $ROMPPSRC"
    echo "CMAKELINEGEN	 = $CMAKELINEGEN"
    echo "# cpu for make = ${njmake}"
}

check_minimum_vars_set(){
    # check for shared vars
    check_minimum_shared_vars_set

    if [ -z $ALLTPLSPATH ];
    then
	if [ -z $EIGENPATH ]; then
	    echo "--all-tpls-path=empty and --eigen-path=empty"
	    echo "if --all-tpls-path=empty, then you need to set --eigen-path"
	    exit 0
	fi

	if [ -z $PYBIND11PATH ]; then
	    echo "--all-tpls-path=empty and --pybind11-path=empty"
	    echo "if --all-tpls-path=empty, you can enable pybind11 if by setting --pybind11-path"
	    echo "Proceding with --pybind11-path=${PYBIND11PATH}"
	fi

	if [ -z $GTESTPATH ]; then
	    echo "--all-tpls-path=empty and --gtest-path=empty"
	    echo "if --all-tpls-path=empty, you can enable gtest if by setting --gtest-path"
	    echo "Proceding with --gtest-path=${GTESTPATH}"
	fi

	if [ -z $TRILINOSPATH ]; then
	    echo "--all-tpls-path=empty and --trilinos-path=empty"
	    echo "if --all-tpls-path=empty, you can enable trilinos if by setting --trilinos-path"
	    echo "Proceding with --trilinos-path=${TRILINOSPATH}"
	fi

	if [ -z $KOKKOSPATH ]; then
	    echo "--all-tpls-path=empty and --kokkos-path=empty"
	    echo "if --all-tpls-path=empty, you can enable kokkos if by setting --kokkos-path"

	    echo "NOTE: if you set -trilinos-path, you do not need to set -kokkos-path"
	    echo "becuase we force using kokkos built as part of Trilinos."
	    echo "The -kokkos-path is only used when trilinos is not linked"
	fi
    fi

    if [[ -z $CMAKELINEGEN ]]; then
	echo "--with-cmake-fnc is empty, must be set"
	exit 0
    fi
}
