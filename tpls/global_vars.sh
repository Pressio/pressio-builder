#!/bin/bash

# source the shared global vars
source ../shared/shared_global_vars.sh

# array storing tpl names
declare -a tpl_names=(gtest eigen trilinos kokkos pybind11)

# array storing the names of the bash functions to generate
# cmake configuring lines
declare -a tpl_cmake_fncs=(default default default default default)

function print_target_tpl_names(){
    echo "tpls = ${tpl_names[@]}"
}

function print_target_tpl_cmake_fncs(){
    echo "cmake_gen_fncs = ${tpl_cmake_fncs[@]}"
}

function print_global_vars(){
    print_shared_global_vars
    print_target_tpl_names
    print_target_tpl_cmake_fncs
}

function check_minimum_vars_set(){
    # check for shared vars
    check_minimum_shared_vars_set
}
