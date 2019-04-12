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

echo ""
echo "--------------------------------------------"
echo "**building ROMPP**"
echo ""

# if all tpls can be found under single dir, then we have
if [[ ! -z $ALLTPLSPATH ]]; then
    # this is because this the structure used by main_tpls.sh
    EIGENPATH=$ALLTPLSPATH/eigen/install
    GTESTPATH=$ALLTPLSPATH/gtest/install

    # if trilinos exists, set, otherwise leave empty
    [[ -d $ALLTPLSPATH/trilinos ]] && TRILINOSPATH=$ALLTPLSPATH/trilinos/install
fi

# test if workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# if rompp and rompp/install exist, check if they need to be wiped
# or if nothing needs to be done (so script exists)
[[ -d rompp && -d rompp/install ]] && check_and_clean rompp

# if we get here, we need to build/install, keeping in mind dependencies.
# make sure these dependencies are updated as they change in rompp
# mpl	  : always needed
# core	  : depends on mpl
# qr	  : depends on mpl, core
# solvers : depends on mpl, core, qr
# svd	  : depends on mpl, core, qr, solvers
# ode	  : depends on mpl, core, solvers
# rom	  : depends on mpl, core, qr, solvers, svd, ode
# apps	  : depends on mpl, core, qr, solvers, svd, ode, rom

# mpl, core always on
buildMPL=ON
# the others are turned on depending on arguments
buildCORE=OFF
buildQR=OFF
buildSOLVERS=OFF
buildSVD=OFF
buildODE=OFF
buildROM=OFF
buildAPPS=OFF

# turn flags on/off according to choices
if [[ " ${pkg_names[@]} " =~ "core" ]]; then
    echo "core on"
    buildCORE=ON
fi
if [[ " ${pkg_names[@]} " =~ "qr" ]]; then
    echo "qr on => turning on also core"
    buildCORE=ON
    buildQR=ON
fi

if [[ " ${pkg_names[@]} " =~ "solvers" ]]; then
    echo "solvers on => turning on also core, qr"
    buildCORE=ON
    buildQR=ON
    buildSOLVERS=ON
fi

if [[ " ${pkg_names[@]} " =~ "svd" ]]; then
    echo "svd on => turning on also core, qr, solvers, svd"
    buildCORE=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
fi

if [[ " ${pkg_names[@]} " =~ "ode" ]]; then
    echo "ode on => turning on also core, solvers"
    buildCORE=ON
    buildSOLVERS=ON
    buildODE=ON
fi

if [[ " ${pkg_names[@]} " =~ "rom" ]]; then
    echo "rom on => turning on also core, qr, solvers, svd, ode"
    buildCORE=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
    buildODE=ON
    buildROM=ON
fi

if [[ " ${pkg_names[@]} " =~ "apps" ]]; then
    echo "apps on => turning on also core, qr, solvers, svd, ode, rom"
    buildCORE=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
    buildODE=ON
    buildROM=ON
    buildAPPS=ON
fi

# create dir if needed
[[ ! -d rompp ]] && mkdir rompp
cd rompp

# if the source is NOT provided by user, then clone repo directly in here
# and set ROMPPSRC to point to this newly cloned repo
if [ -z ${ROMPPSRC} ]; then
    [[ ! -d rompp ]] && git clone --recursive git@gitlab.com:fnrizzi/rompp.git
    cd rompp && git checkout develop && cd ..
    ROMPPSRC=${PWD}/rompp
fi

# create build
[[ -d build ]] && rm -rf build/* || mkdir build
cd build

# source all generator functions
source ${THISDIR}/cmake_building_blocks.sh
source ${THISDIR}/cmake_line_generator.sh

# make sure the global var CMAKELINE is empty
CMAKELINE=""

# call the generator to build the string for cmake line
# this will append to the global var CMAKELINE
${CMAKELINEGEN}

# append prefix
CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "
# append the location of the source
CMAKELINE+="${ROMPPSRC}"

# run the cmake commnad
echo ""
echo "cmake command: "
echo -e "cmake $CMAKELINE"
echo ""
cmake eval ${CMAKELINE}

# build
make -j 6 install

# return where we started from
cd ${THISDIR}
