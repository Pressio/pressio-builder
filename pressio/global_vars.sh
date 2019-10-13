#!/bin/bash

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

# pressio git repo src
PRESSIOSRC=

# name of the cmake configuring line
CMAKELINEGEN=default

# n to use for parallelizing make
njmake=6

function print_global_vars(){
    print_shared_global_vars
    echo "EIGENPATH	      = $EIGENPATH"
    echo "GTESTPATH	      = $GTESTPATH"
    echo "TRILINOSPATH	      = $TRILINOSPATH"
    echo "KOKKOSPATH	      = $KOKKOSPATH"
    echo "PYBIND11PATH	      = $PYBIND11PATH"
    echo "PRESSIOSRC	      = $PRESSIOSRC"
    echo "CMAKELINEGEN	      = $CMAKELINEGEN"
    echo "# cpu for make      = ${njmake}"
}

function check_minimum_vars_set(){
    # check for shared vars
    check_minimum_shared_vars_set
    echo "${fggreen}Minimum shared vars found: ok! ${fgrst}"

    if [ -z $EIGENPATH ]; then
	echo "${fgred}--eigen-path is empty, you must set it. ${fgrst}"
	echo "${fgred}Eigen is a required TPL. Terminating.${fgrst}"
	exit 0
    fi

    if [ -z $PYBIND11PATH ]; then
	echo ""
	echo "--pybind11-path is empty"
	echo "${fggreen}Since pybind11 is optional, I proceed.${fgrst}"
    fi

    if [ -z $GTESTPATH ]; then
	echo "--gtest-path is empty"
	echo "${fggreen}Since gtest is optional, I proceed.${fgrst}"
    fi

    if [ -z $TRILINOSPATH ]; then
	echo "--trilinos-path=empty"
	echo "${fggreen}Since Trilinos is optional, I proceed.${fgrst}"
    fi

    if [ -z $KOKKOSPATH ]; then
	echo "--kokkos-path is empty"
	echo "NOTE: if you set -trilinos-path, you do not need to set -kokkos-path"
	echo "becuase we force using kokkos built as part of Trilinos."
	echo "The -kokkos-path is only used when trilinos is not linked"
	echo "${fggreen}Kokkos is optional, I proceed.${fgrst}"
    fi

    if [[ -z $CMAKELINEGEN ]]; then
	echo "${fgred}--cmake-generator-name is is empty, must be set. Terminating.${fgrst}"
	exit 0
    fi
}
