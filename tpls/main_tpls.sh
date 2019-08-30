#!/bin/bash

echo "Bash version ${BASH_VERSION}"
set -e

# load all global variables for TPLs
source global_vars.sh

# parse cline arguments
source cmd_line_options.sh

# check that all basic variables are set
# (if not minimum set found, script exits)
check_minimum_vars_set

echo ""
echo "--------------------------------------------"
echo " current setting is: "
echo ""
print_global_vars
echo ""

# source helper functions
source ../shared/help_fncs.sh

# set env if not already set
call_env_script

# check that tpl names parsed from cmd line args are admissible
echo "checking tpl names are admissible"
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
echo "done checking tpl names!"
print_target_tpl_names
print_target_tpl_cmake_fncs


echo ""
echo "--------------------------------------------"
echo "**building tpls**"
echo ""

function build_gtest() {
    local DOBUILD=OFF
    local myfnc=$1
    echo "target fnc = ${myfnc}.sh"
    [[ -d gtest ]] && check_and_clean gtest || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/gtest_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/gtest_cmake_lines/cmake_line_generator.sh

	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${THISDIR}/build_gtest.sh
	build_gtest $myfnc
    fi
}

function build_trilinos() {
    local DOBUILD=OFF
    local myfnc=$1
    local nJmake=4
    echo "target fnc = ${myfnc}.sh"
    [[ -d trilinos ]] && check_and_clean trilinos || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/trilinos_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/trilinos_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${THISDIR}/build_trilinos.sh
	build_trilinos $myfnc $nJmake
    fi
}

function build_kokkos() {
    local DOBUILD=OFF
    local myfnc=$1
    local nJmake=4
    echo "target fnc = ${myfnc}.sh"
    [[ -d kokkos ]] && check_and_clean kokkos || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
    	# source all generator functions
    	source ${THISDIR}/kokkos_cmake_lines/cmake_building_blocks.sh
    	source ${THISDIR}/kokkos_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

    	# source and call build function
    	source ${THISDIR}/build_kokkos.sh
    	build_kokkos $myfnc $nJmake
    fi
}

function build_eigen() {
    local DOBUILD=OFF
    local myfnc=$1
    echo "target fnc = ${myfnc}.sh"
    [[ -d eigen ]] && check_and_clean eigen || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/eigen_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/eigen_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${THISDIR}/build_eigen.sh
	build_eigen $myfnc
    fi
}

function build_pybind11() {
    local DOBUILD=OFF
    local myfnc=$1
    echo "target fnc = ${myfnc}.sh"
    [[ -d pybind11 ]] && check_and_clean pybind11 || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/pybind11_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/pybind11_cmake_lines/cmake_line_generator.sh
	# if a bash file with custom generator functions is provided, source it
	if [ ! -z $CMAKELINEGENFNCscript ]; then
	    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
	    source ${CMAKELINEGENFNCscript}
	fi

	# source and call build function
	source ${THISDIR}/build_pybind11.sh
	build_pybind11 $myfnc
    fi
}

# test is workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir -p $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# if you have supported/good cmake
have_admissible_cmake
res=$?
if [[ "$res" == "1" ]]; then
    exit 2
else
    echo "you have admissible cmake"
fi

# now loop through TPLS and build
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}
    fnc=${tpl_cmake_fncs[i]}
    echo "processing tpl = ${name}"

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
cd ${THISDIR}
