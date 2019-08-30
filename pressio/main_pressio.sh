#!/bin/bash

set -e

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

# if you have supported/good cmake
have_admissible_cmake
res=$?
if [[ "$res" == "1" ]]; then
    exit 2
else
    echo "you have admissible cmake"
fi

echo ""
echo "--------------------------------------------"
echo "**building PRESSIO**"
echo ""

# if all tpls can be found under single dir, then we have
if [[ ! -z $ALLTPLSPATH ]]; then
    EIGENPATH=$ALLTPLSPATH/eigen/install

    # if exists, set, otherwise leave empty
    [[ -d $ALLTPLSPATH/gtest ]] && GTESTPATH=$ALLTPLSPATH/gtest/install
    [[ -d $ALLTPLSPATH/pybind11 ]] && PYBIND11PATH=$ALLTPLSPATH/pybind11/install
    [[ -d $ALLTPLSPATH/trilinos ]] && TRILINOSPATH=$ALLTPLSPATH/trilinos/install

    # if trilinos exists, force using Kokkos inside that
    if [[ -d $ALLTPLSPATH/trilinos ]]; then
	KOKKOSPATH=$ALLTPLSPATH/trilinos/install
    else
	# find the kokkos installation
	[[ -d $ALLTPLSPATH/kokkos ]] && KOKKOSPATH=$ALLTPLSPATH/kokkos/install
    fi
fi

# test if workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir -p $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# if pressio and pressio/install exist, check if they need to be wiped
# or if nothing needs to be done (so script exists)
[[ -d pressio && -d pressio/install ]] && check_and_clean pressio

# if we get here, we need to build/install, keeping in mind dependencies.
# make sure these dependencies are updated as they change in pressio
# mpl		: always needed
# utils		: always needed
# containers	: depends on mpl, utils
# qr		: depends on mpl, utils, containers
# solvers	: depends on mpl, utils, containers, qr
# svd		: depends on mpl, utils, containers, qr, solvers
# ode		: depends on mpl, utils, containers, solvers
# rom		: depends on mpl, utils, containers, qr, solvers, svd, ode
# apps		: depends on mpl, utils, containers, qr, solvers, svd, ode, rom

# mpl, utils always on
buildMPL=ON
buildUTILS=ON
# the others are turned on depending on arguments
buildCONTAINERS=OFF
buildQR=OFF
buildSOLVERS=OFF
buildSVD=OFF
buildODE=OFF
buildROM=OFF
buildAPPS=OFF

# turn flags on/off according to choices
if [[ " ${pkg_names[@]} " =~ "containers" ]]; then
    echo "mpl, utils and containers on"
    buildCONTAINERS=ON
fi
if [[ " ${pkg_names[@]} " =~ "qr" ]]; then
    echo "qr on => turning on also mpl, utils, containers"
    buildCONTAINERS=ON
    buildQR=ON
fi

if [[ " ${pkg_names[@]} " =~ "solvers" ]]; then
    echo "solvers on => turning on also mpl, utils, containers, qr"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
fi

if [[ " ${pkg_names[@]} " =~ "svd" ]]; then
    echo "svd on => turning on also mpl, utils, containers, qr, solvers, svd"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
fi

if [[ " ${pkg_names[@]} " =~ "ode" ]]; then
    echo "ode on => turning on also mpl, utils, containers, solvers"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildODE=ON
fi

if [[ " ${pkg_names[@]} " =~ "rom" ]]; then
    echo "rom on => turning on also mpl, utils, containers, qr, solvers, svd, ode"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
    buildODE=ON
    buildROM=ON
fi

if [[ " ${pkg_names[@]} " =~ "apps" ]]; then
    echo "apps on => turning on also mpl, utils, containers, qr, solvers, svd, ode, rom"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
    buildODE=ON
    buildROM=ON
    buildAPPS=ON
fi

# create dir if needed
[[ ! -d pressio ]] && mkdir pressio
cd pressio

# if the source is NOT provided by user, then clone repo directly in here
# and set PRESSIOSRC to point to this newly cloned repo
echo "PRESSIOSRC = ${PRESSIOSRC}"
if [[ -z ${PRESSIOSRC} ]]; then
    [[ ! -d pressio ]] && git clone --recursive git@gitlab.com:fnrizzi/pressio.git
    cd pressio && git checkout develop && cd ..
    PRESSIOSRC=${PWD}/pressio
fi

# create build
[[ -d build ]] && rm -rf build/* || mkdir build
cd build

#----------------------------------------------
# source building blocks: this is needed always
source ${THISDIR}/cmake_building_blocks.sh

# the basic/default generatos are always loaded
source ${THISDIR}/cmake_line_generator.sh

# if a bash file with custom generator functions is provided, source it
if [ ! -z $CMAKELINEGENFNCscript ]; then
    echo "sourcing custom cmake generator functions from ${CMAKELINEGENFNCscript}"
    source ${CMAKELINEGENFNCscript}
fi
#----------------------------------------------

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
    echo "${CMAKELINEGEN} cannot be empty, need to set one, exiting"
    exit 1
fi
${CMAKELINEGEN}

# after generator was called, now finalize cmakeline
# append cxx flags
CMAKELINE+="-D CMAKE_CXX_FLAGS:STRING='${CXXFLAGS}' "
# append extra link flags
CMAKELINE+="-D pressio_EXTRA_LINK_FLAGS:STRING='${EXTRALINKFLAGS}' "

# append prefix
CMAKELINE+="-D CMAKE_INSTALL_PREFIX:PATH=../install "
# append the location of the source
CMAKELINE+="${PRESSIOSRC}"

# run the cmake commnad
echo ""
echo "cmake command: "
echo -e "cmake $CMAKELINE"
echo ""
cmake eval ${CMAKELINE}

# build
echo "build with" make -j ${njmake} install}
make -j ${njmake} install

# if we are on cee machines, change permissions
is_cee_build_machine
iscee=$?
if [[ "iscee" == "1" ]]; then
    echo "changing SGID permissions to ${WORKDIR}/pressio/install"
    chmod g+rxs ${WORKDIR} #not recursive on purpose
    chmod g+rxs ${WORKDIR}/pressio #not recursive on purpose
    chmod -R g+rxs ${WORKDIR}/pressio/install
fi

# return where we started from
cd ${THISDIR}
