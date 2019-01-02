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

#----------------------------------
# step : start building ROMPP

echo ""
echo "--------------------------------------------"
echo "**building ROMPP**"
echo ""

buildCORE=OFF
buildQR=OFF
buildSOLVERS=OFF
buildSVD=OFF
buildODE=OFF
buildROM=OFF

# if all tpls can be found under single dir, then we have
if [[ ! -z $ALLTPLSPATH ]]; then
    # this is because this the structure used by main_tpls.sh
    EIGENPATH=$ALLTPLSPATH/eigen/install
    GTESTPATH=$ALLTPLSPATH/gtest/install
    TRILINOSPATH=$ALLTPLSPATH/trilinos/install
fi

# test is workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# if rompp and rompp/install exist, check if they need to be wiped
# or if nothing needs to be done (so script exists)
[[ -d rompp && -d rompp/install ]] && check_and_clean rompp

# if we get here, it means that we need to build and install
# so check which packages we need to build
[[ " ${pkg_names[@]} " =~ "core" ]]    && buildCORE=ON
[[ " ${pkg_names[@]} " =~ "qr" ]]      && buildQR=ON
[[ " ${pkg_names[@]} " =~ "solvers" ]] && buildSOLVERS=ON
[[ " ${pkg_names[@]} " =~ "svd" ]]     && buildSVD=ON
[[ " ${pkg_names[@]} " =~ "ode" ]]     && buildODE=ON
[[ " ${pkg_names[@]} " =~ "rom" ]]     && buildROM=ON

# do some processing to pass to the cmake line
is_shared=ON
[[ $MODElib == static ]] && is_shared=OFF
echo "is_shared = $is_shared"
link_search_static=OFF
[[ $MODElib == static ]] && link_search_static=ON

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

# source all functions containing cmake lines for configuring
source ${THISDIR}/rompp_cmake_lines.sh
# call function to configure
$CMAKECONFIGfnc

# build
make -j 4 install

# return where we started from
cd ${THISDIR}
