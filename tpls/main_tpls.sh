#!/usr/bin/env bash

# exit when there is error code
set -e

# source colors for printing
source ../shared/colors.sh

# print version of bash
echo "Using bash version ${BASH_VERSION}"

# source the shared global vars
source ../shared/shared_global_vars.sh

# load the global variables defined for TPLs
source global_vars.sh

# parse cline arguments
source cmd_line_options.sh

# check that all basic variables are set
# (if not minimum set found, script exits)
check_minimum_vars_set

# print the current setting
echo ""
echo "${fgyellow}+++ The setting is as follows: +++ ${fgrst}"
print_global_vars
echo ""

# source helper functions
source ../shared/help_fncs.sh

# set env if not already set
call_env_script

# check that tpl names parsed from cmd line args are admissible
echo ""
echo "${fgyellow}+++ Checking if TPL names are admissible +++${fgrst}"
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}

    if [ ${name} != eigen ] &&\
	   [ ${name} != gtest ] &&\
	   [ ${name} != trilinos ] &&\
	   [ ${name} != kokkos ] &&\
	   [ ${name} != pybind11 ];
    then
	echo "found at least one non-admissible tpl name passed"
	echo "valid choices: eigen, gtest, trilinos, kokkos, pybind11"
	exit 1
    fi
done
print_target_tpl_names
print_target_tpl_cmake_fncs
echo "${fggreen}All TPL names seem valid: ok! ${fgrst}"


#################################
# building all TPLs happens below

function build_gtest() {
    local DOBUILD=OFF
    local myfnc=$1
    # the following is short syntax for if then else
    [[ -d gtest ]] && check_and_clean gtest || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${ORIGDIR}/gtest_cmake_lines/cmake_building_blocks.sh
	source ${ORIGDIR}/gtest_cmake_lines/cmake_line_generator.sh

	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${ORIGDIR}/build_gtest.sh
	build_gtest $myfnc
    fi
}

function build_pybind11() {
    local DOBUILD=OFF
    local myfnc=$1
    # the following is short syntax for if then else
    [[ -d pybind11 ]] && check_and_clean pybind11 || DOBUILD=ON

    # if I need to, do the build
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${ORIGDIR}/pybind11_cmake_lines/cmake_building_blocks.sh
	source ${ORIGDIR}/pybind11_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${ORIGDIR}/build_pybind11.sh
	build_pybind11 $myfnc
    fi
}

function build_trilinos() {
    local DOBUILD=OFF
    local myfnc=$1
    local nJmake=4
    # the following is short syntax for if then else
    [[ -d trilinos ]] && check_and_clean trilinos || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${ORIGDIR}/trilinos_cmake_lines/cmake_building_blocks.sh
	source ${ORIGDIR}/trilinos_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${ORIGDIR}/build_trilinos.sh
	build_trilinos $myfnc $nJmake
    fi
}

function build_kokkos() {
    local DOBUILD=OFF
    local myfnc=$1
    local nJmake=4
    # the following is short syntax for if then else
    [[ -d kokkos ]] && check_and_clean kokkos || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
    	# source all generator functions
    	source ${ORIGDIR}/kokkos_cmake_lines/cmake_building_blocks.sh
    	source ${ORIGDIR}/kokkos_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

    	# source and call build function
    	source ${ORIGDIR}/build_kokkos.sh
    	build_kokkos $myfnc $nJmake
    fi
}

function build_eigen() {
    local DOBUILD=OFF
    local myfnc=$1
    # the following is short syntax for if then else
    [[ -d eigen ]] && check_and_clean eigen || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${ORIGDIR}/eigen_cmake_lines/cmake_building_blocks.sh
	source ${ORIGDIR}/eigen_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${ORIGDIR}/build_eigen.sh
	build_eigen $myfnc
    fi
}

# test is workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir -p $WORKDIR)

# enter working dir: the script for each tpl MUST be run from within target dir
cd $WORKDIR

# check if you have valid cmake
have_admissible_cmake && res=$?
if [[ "$res" == "1" ]]; then
    exit 22
else
    echo "${fggreen}Valid cmake found: ok! ${fgrst}"
fi

# now loop through TPLS and build
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}
    fnc=${tpl_cmake_fncs[i]}
    echo ""
    echo "${fgyellow}+++ Processing tpl=${name} +++${fgrst}"

    [[ ${name} = "eigen" ]] && build_eigen ${fnc}
    [[ ${name} = "gtest" ]] && build_gtest ${fnc}
    [[ ${name} = "trilinos" ]] && build_trilinos ${fnc}
    [[ ${name} = "kokkos" ]] && build_kokkos ${fnc}
    [[ ${name} = "pybind11" ]] && build_pybind11 ${fnc}
done

# if we are on cee machines, change permissions
is_cee_build_machine
iscee=$?
if [[ "iscee" == "1" ]]; then
    chmod -R g+rxs ${WORKDIR}
fi

# return where we started from
cd ${ORIGDIR}
