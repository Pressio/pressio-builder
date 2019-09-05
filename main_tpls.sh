#!/usr/bin/env bash

# exit when there is error code
set -e

# source colors for printing
source ./shared/colors.sh

# print version of bash
echo "Using bash version ${BASH_VERSION}"

# source the shared global vars
source ./shared/shared_global_vars.sh

# load the global variables defined for TPLs
source ./tpls/global_vars.sh

# parse cline arguments
source ./tpls/cmd_line_options.sh

# check that all basic variables are set
# (if not minimum set found, script exits)
check_minimum_vars_set

# print the current setting
echo ""
echo "${fgyellow}+++ The setting is as follows: +++ ${fgrst}"
print_global_vars
echo ""

# source helper functions
source ./shared/help_fncs.sh

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


# if a bash file with custom generator functions is provided, source it
if [ ! -z $CMAKELINEGENFNCscript ]; then
    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
    source ${CMAKELINEGENFNCscript}
fi

# now loop through TPLS and build
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}
    fnc=${tpl_cmake_fncs[i]}
    echo ""
    echo "${fgyellow}+++ Processing tpl=${name} +++${fgrst}"

    # do the actual build
    DOBUILD=OFF
    # the following is short syntax for if then else
    [[ -d ${name} ]] && check_and_clean ${name} || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${ORIGDIR}/tpls/${name}_cmake_lines/cmake_building_blocks.sh
	source ${ORIGDIR}/tpls/${name}_cmake_lines/default_cmake_line_generator.sh

	# source and call build function
	source ${ORIGDIR}/tpls/build_${name}.sh
	build_${name} ${fnc}
    fi
done

# if we are on cee machines, change permissions
is_cee_build_machine
iscee=$?
if [[ "iscee" == "1" ]]; then
    chmod -R g+rxs ${WORKDIR}
fi

# return where we started from
cd ${ORIGDIR}
