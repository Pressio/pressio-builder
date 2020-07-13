#!/usr/bin/env bash

# exit when there is error code
set -e

# print version of bash
echo "Using bash version ${BASH_VERSION}"

# source colors for printing
source ./shared/colors.sh

############################################
# load helpers
############################################

# source the shared global vars
source ./shared/shared_global_vars.sh
# load the shared helpers fncs
source ./shared/helper_fncs.sh

# load the global variables defined for TPLs
source ./tpls/global_vars.sh
# load the helpers for TPLs
source ./tpls/helper_fncs.sh

# source TPLs info (versions, URLs, etc.)
source ./tpls/tpls_versions_details.sh

############################################
# parse agrs
############################################

# parse cline arguments
source ./tpls/cmd_line_options.sh

# check basic variables are set (if not, script exits)
check_minimum_vars_are_set

# print the current setting
echo ""
echo "${fgyellow}+++ Using the following setup: +++ ${fgrst}"
print_global_vars
echo ""

# set env if not already set
call_env_script

# check if you have a valid cmake
have_admissible_cmake
echo "${fggreen}Valid cmake found: ok! ${fgrst}"

###########################################################
# check tpl names parsed from cmd line args are admissible
###########################################################

echo ""
echo "${fgyellow}+++ Checking if TPL names are admissible +++${fgrst}"
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}

    if [ ${name} != eigen ] &&\
	   [ ${name} != gtest ] &&\
	   [ ${name} != trilinos ] &&\
	   [ ${name} != kokkos ] &&\
	   [ ${name} != kokkos-kernels ] &&\
	   [ ${name} != pybind11 ];
    then
	echo "found at least one non-admissible tpl name passed"
	echo "valid choices: eigen, gtest, trilinos, kokkos, kokkos-kernels, pybind11"
	exit 1
    fi
done

# if user selects (a) trilinos, kokkos or (b) trilinos and kokkos-kernels
# or (c) trilinos, kokkos, kokkos-kernels
# we drop the standalone kokkos/kernels because these already built as part of trilinos
check_if_both_trilinos_kokkos_are_selected

# the order with which you build tpls matters in some cases.
# e.g. kokkos must be built before kokkos-kernels, so make sure the order of the tpls list is correct
check_tpls_order_is_admissible

print_target_tpl_names
print_target_tpl_cmake_fncs
echo "${fggreen}All TPL names are valid! ${fgrst}"

#################################
# build all target TPLs
#################################

# test is workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir -p $WORKDIR)

# enter working dir: the script for each tpl MUST be run from within target dir
cd $WORKDIR

# if a bash file with custom generator functions is provided, source it
if [ ! -z $CMAKELINEGENFNCscript ]; then
    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
    source ${CMAKELINEGENFNCscript}
fi

# now loop through TPLS and build
for ((i=0;i<${#tpl_names[@]};++i)); do
    # name of current tpls to build
    name=${tpl_names[i]}
    echo ""
    echo "${fgyellow}+++ Processing tpl=${name} +++${fgrst}"

    # cmake generator function to use (see tpls/global_vars.sh for default setting)
    fnc=${tpl_cmake_fncs[i]}

    # do the actual build
    DOBUILD=OFF
    # check if we need to wipe and redo
    [[ -d ${name} ]] && check_and_clean ${name} || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
	# source all generator functions
	source ${ORIGDIR}/tpls/all/${name}/cmake_building_blocks.sh
	source ${ORIGDIR}/tpls/all/${name}/default_cmake_line_generator.sh

	# source and call build function
	source ${ORIGDIR}/tpls/all/${name}/build_${name}.sh
	build_${name} ${fnc}
    fi
done

# check if workdir is there, and delete if dryrun = yes
[[ -d $WORKDIR && $DRYRUN == yes ]] && rm -rf ${WORKDIR}

# return where we started from
cd ${ORIGDIR}
