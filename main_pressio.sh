#!/usr/bin/env bash

# exit when there is error code
set -e

# print version of bash
echo "Bash version ${BASH_VERSION}"

# source colors for printing
source ./shared/colors.sh

############################################
# set up few things and read args
############################################

# source the shared global vars
source ./shared/shared_global_vars.sh

# load the global variables defined for TPLs
source ./pressio/global_vars.sh

# parse cline arguments
source ./pressio/cmd_line_options.sh

# check basic variables are set (if not, script exits)
check_minimum_vars_set

# print the current setting
echo ""
echo "${fgyellow}+++ The setting is as follows: +++ ${fgrst}"
print_global_vars
echo ""

# source TPLs info (versions, URLs, etc.)
source ./tpls/tpls_versions_details.sh

# source helper functions
source ./shared/help_fncs.sh

# set env if not already set
call_env_script

############################################
# check if you have a valid cmake
############################################

have_admissible_cmake
echo "${fggreen}Valid cmake found: ok! ${fgrst}"

############################################
# source generator functions for Pressio etc
############################################

# source building blocks: this is needed always
source ./pressio/cmake_building_blocks.sh

# the basic/default generatos are always loaded
source ./pressio/default_cmake_line_generator.sh

# if a bash file with custom generator functions is provided, source it
if [ ! -z $CMAKELINEGENFNCscript ]; then
    echo "${fgyellow}Sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}${fgrst}"
    source ${CMAKELINEGENFNCscript}
fi


############################################
# enter the actual conf/build/install stage
############################################

# test if workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir -p $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# if pressio and pressio/install exist, check if they need to be wiped
# or if nothing needs to be done (so script exists)
[[ -d pressio && -d pressio/install ]] && check_and_clean pressio

# create directory if needed
[[ ! -d pressio ]] && mkdir pressio
cd pressio

# if Pressio source is NOT provided by user, then clone repo directly in here
# and set PRESSIOSRC to point to this newly cloned repo
if [[ -z ${PRESSIOSRC} ]]; then
    echo "${fgyewllo}You did not specify the Pressio source, so I am cloning it.${fgrst}"
    if [ ! -d pressio ]; then
	git clone --recursive git@github.com:Pressio/pressio.git
    fi
    cd pressio && git checkout develop && cd ..
    PRESSIOSRC=${PWD}/pressio
fi

# create build
[[ -d build ]] && rm -rf build/* || mkdir build
cd build

############################################
# here the cmake line is constructed
############################################

# global var CMAKELINE is empty
CMAKELINE=""
# we want to customize CMAKE_CXX_FLAGS, define it empty here
CXXFLAGS=""
# also, extra link flags to PRESSIO if needed
EXTRALINKFLAGS=""

# the generator function MUST be called here after
# above vars have been defined.
# calling the generator will build the string for cmake line
# this will append to the global var CMAKELINE, and will
# change the above flags too if needed
if [[ -z ${CMAKELINEGEN} ]]; then
    echo "${fgred} The ${CMAKELINEGEN} cannot be empty, need to set it. Terminating. ${fgrst}"
    exit 1
fi

# call the generator to build the string for cmake line
# this will append to the global var CMAKELINE
${CMAKELINEGEN}

# after generator was called, now finalize cmakeline
# append cxx flags
CMAKELINE+="-D CMAKE_CXX_FLAGS:STRING='${CXXFLAGS}' "

# append prefix
CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "
# append the location of the source
CMAKELINE+="${PRESSIOSRC}"

# print the cmake commnad that will be used
echo ""
echo "For Pressio, the cmake command to use is:"
echo "${fgcyan}cmake ${CMAKELINE}${fgrst}"
echo ""


############################################
# configured, build and install
############################################
if [ $DRYRUN == no ]; then
    echo "${fgyellow}Starting config, build and install of Pressio ${fgrst}"

    # configure
    cmake eval ${CMAKELINE}

    # build
    echo "build with" make -j ${njmake}
    make -j ${njmake}

    # install
    make install
else
    echo "${fgyellow}with dryrun=0, here I would config, build and install Pressio ${fgrst}"
fi

# return where we started from
cd ${ORIGDIR}
