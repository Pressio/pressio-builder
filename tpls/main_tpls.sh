#!/bin/bash

echo "Bash version ${BASH_VERSION}"

# PWD will be updated if we change directory
PWD=`pwd`

# load all global variables
source global_vars.sh

# step : parse cline arguments
source cmd_line_options.sh

# check that all basic variables are set, otherwise leave
check_minimum_vars_set

echo ""
echo "--------------------------------------------"
echo " current setting is: "
echo ""
print_global_vars

# source helper functions
source ../help_fncs.sh

# set env if not already set
call_env_script

# check that tpl names are admissible
echo "checking tpl names are admissible"
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}

    if [[ ${name} != eigen ] &&\
	   [ ${name} != gtest ] &&\
	   [ ${name} != trilinos ] &&\
	   [ ${name} != kokkos ] &&\
	   [ ${name} != pybind11 ]];
    then
	echo "non-admissible tpl name passed"
	echo "valid choices: eigen, gtest, trilinos, kokkos, pybind11"
	exit 0
    fi
done
echo "done checking tpl names!"
print_target_tpl_names
print_target_tpl_cmake_fncs

echo ""
echo "--------------------------------------------"
echo "**building tpls**"
echo ""

build_gtest() {
    local DOBUILD=OFF
    local myfnc=$1
    echo "target fnc = ${myfnc}.sh"
    [[ -d gtest ]] && check_and_clean gtest || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/gtest_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/gtest_cmake_lines/cmake_line_generator.sh
	# source and call build function
	source ${THISDIR}/build_gtest.sh
	build_gtest $myfnc
    fi
}

build_trilinos() {
    local DOBUILD=OFF
    local myfnc=$1
    local nJmake=4
    echo "target fnc = ${myfnc}.sh"
    [[ -d trilinos ]] && check_and_clean trilinos || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/trilinos_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/trilinos_cmake_lines/cmake_line_generator.sh
	# source and call build function
	source ${THISDIR}/build_trilinos.sh
	build_trilinos $myfnc $nJmake
    fi
}

build_kokkos() {
    local DOBUILD=OFF
    local myfnc=$1
    local nJmake=4
    echo "target fnc = ${myfnc}.sh"
    [[ -d kokkos ]] && check_and_clean kokkos || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
    	# source all generator functions
    	source ${THISDIR}/kokkos_cmake_lines/cmake_building_blocks.sh
    	source ${THISDIR}/kokkos_cmake_lines/cmake_line_generator.sh
    	# source and call build function
    	source ${THISDIR}/build_kokkos.sh
    	build_kokkos $myfnc $nJmake
    fi
}

build_eigen() {
    local DOBUILD=OFF
    local myfnc=$1
    echo "target fnc = ${myfnc}.sh"
    [[ -d eigen ]] && check_and_clean eigen || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/eigen_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/eigen_cmake_lines/cmake_line_generator.sh
	# source and call build function
	source ${THISDIR}/build_eigen.sh
	build_eigen $myfnc
    fi
}

build_pybind11() {
    local DOBUILD=OFF
    local myfnc=$1
    echo "target fnc = ${myfnc}.sh"
    [[ -d pybind11 ]] && check_and_clean pybind11 || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${THISDIR}/pybind11_cmake_lines/cmake_building_blocks.sh
	source ${THISDIR}/pybind11_cmake_lines/cmake_line_generator.sh
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
if [[ is_cee_build_machine == 0 ]]; then
    echo "changing SGID permissions to ${WORKDIR}"
    chmod -R g+rxs ${WORKDIR}
fi

# return where we started from
cd ${THISDIR}
