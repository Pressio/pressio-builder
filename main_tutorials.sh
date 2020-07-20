#!/usr/bin/env bash

# exit when there is error code
set -e

############################################
# set up few things and read args
############################################

# source colors for printing
source ./shared/colors.sh

# print version of bash
echo "Bash version ${BASH_VERSION}"

# source the shared global vars
source ./shared/shared_global_vars.sh

# # source helper functions
source ./shared/helper_fncs.sh

# load the global variables defined for TPLs
source ./tutorials/global_vars.sh

# parse cline arguments
source ./tutorials/cmd_line_options.sh

# check that all basic variables are set
# (if not minimum set found, script exits)
check_minimum_vars_set

# print the current setting
echo ""
echo "${fgyellow}+++ The setting is as follows: +++ ${fgrst}"
print_global_vars
echo ""

# set env if not already set
call_env_script

############################################
# check if you have a valid cmake
############################################

have_admissible_cmake
echo "${fggreen}Valid cmake found: ok! ${fgrst}"


############################################
# source generator functions
############################################

# source building blocks: this is needed always
source ./tutorials/cmake_building_blocks.sh

# the basic/default generatos are always loaded
source ./tutorials/default_cmake_line_generator.sh


############################################
# enter the actual conf/build/install stage
############################################

# test if workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir -p $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# if pressio-tutorials exists, check if it needs to be wiped
# or if nothing needs to be done (so script exists)
[[ -d pressio-tutorials ]] && check_and_clean pressio-tutorials

# create directory if needed
[[ ! -d pressio-tutorials ]] && mkdir pressio-tutorials
cd pressio-tutorials

# if source is NOT provided by user, then clone repo directly in here
# and set PRESSIOTUTORIALSSRC to point to this newly cloned repo
if [[ -z ${PRESSIOTUTORIALSSRC} ]]; then
    echo "${fgyewllo}You did not specify the pressio-tutorials source, so I am cloning it.${fgrst}"

    if [ ! -d pressio-tutorials ]; then
	git clone git@github.com:Pressio/pressio-tutorials.git
    fi
    cd pressio-tutorials && cd ..
    PRESSIOTUTORIALSSRC=${PWD}/pressio-tutorials
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
# also, extra link flags
EXTRALINKFLAGS=""

# call the generator to build the string for cmake line
# this will append to the global var CMAKELINE
${CMAKELINEGEN}

# the generator function MUST be called here after
# above vars have been defined.
# calling the generator will build the string for cmake line
# this will append to the global var CMAKELINE
if [[ -z ${CMAKELINE} ]]; then
    echo "${fgred} CMAKELINE is empty, this means I cannot configure.${fgrst}"
    echo "${fgred} Something is wrong with how to overwrite CMAKELINE. Terminating.${fgrst}"
    exit 1
fi

# after generator was called, now finalize cmakeline
# append cxx flags
CMAKELINE+="-D CMAKE_CXX_FLAGS:STRING='${CXXFLAGS}' "

# append prefix
CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "
# append the location of the source
CMAKELINE+="${PRESSIOTUTORIALSSRC}"

# print the cmake commnad that will be used
echo ""
echo "For pressio-tutorials, the cmake command to use is:"
echo "${fgcyan}cmake ${CMAKELINE}${fgrst}"
echo ""


############################################
# configured, build and install
############################################
if [ $DRYRUN == no ]; then
    echo "${fgyellow}Starting config and build of pressio-tutorials ${fgrst}"

    # configure
    cmake eval ${CMAKELINE}

    # build
    echo "build with" make -j ${njmake}
    make -j ${njmake}
else
    echo "${fgyellow}with dryrun=1, here I would config and build pressio-tutorials ${fgrst}"
fi

# return where we started from
cd ${ORIGDIR}
