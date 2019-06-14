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
# path to dir where pybind11 is installed
PYBIND11PATH=
# path to dir where all tpls are installed
# structure must follow what main_tpls.sh does
ALLTPLSPATH=

# rompp git repo src
ROMPPSRC=

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
    echo "PYBIND11PATH   = $PYBIND11PATH"
    echo "ALLTPLSPATH    = $ALLTPLSPATH"
    echo "ROMPPSRC       = $ROMPPSRC"
    echo "CMAKELINEGEN	 = $CMAKELINEGEN"
    echo "# cpu for make = ${njmake}"
}

check_minimum_vars_set(){
    # check for shared vars
    check_minimum_shared_vars_set

    if [[ -z $ALLTPLSPATH && -z $EIGENPATH && \
	  -z $GTESTPATH && -z $TRILINOSPATH && -z $PYBIND11PATH ]]; then
	echo "--all-tpls-path is empty, and all individual ones are empty"
	echo "Either you set --all-tpls-path, or each "
	echo "of -eigen-path, -gtest-path, -trilinos-path, -pybind11-path"
	exit 0
    fi

    if [[ -z $CMAKELINEGEN ]]; then
	echo "--with-cmake-fnc is empty, must be set"
	exit 0
    fi
}
