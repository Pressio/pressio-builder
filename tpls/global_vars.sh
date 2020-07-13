#!/usr/bin/env bash

# array storing tpl names
declare -a tpl_names=(gtest eigen trilinos pybind11)

# array storing the names of the bash functions to generate
# cmake configuring lines
declare -a tpl_cmake_fncs=(default default default default)
