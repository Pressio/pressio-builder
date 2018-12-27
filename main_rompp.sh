#!/bin/bash

echo "Bash version ${BASH_VERSION}"

#----------------------------------
# step : define global variables

# PWD will be updated if we change directory
PWD=`pwd`

# THISDIR will always contain the folder we start from
THISDIR=$PWD

# array storing packages
declare -a pkg_names=(core)

EIGENPATH=
GTESTPATH=
TRILINOSPATH=
ALLTPLSPATH=

# rompp git repo src
ROMPPSRC=

# store the working dir
ARCH=

# store the target working dir
WORKDIR=

# bool to wipe existing content of target directory
WIPEEXISTING=ON

# build mode: DEBUG/RELEASE
MODEbuild=DEBUG

# build/link shared or static lib
MODElib=shared

# env script
SETENVscript=


#----------------------------------
# step : parse cline arguments

echo ""
echo "--------------------------------------------"
echo "**parsing cline arguments**"
echo ""

for option; do
    echo $option
    case $option in
	# print help
	-help | --help | -h)
	    want_help=yes
	    ;;

	-arch=* | --arch=* )
	    ARCH=`expr "x$option" : "x-*arch=\(.*\)"`
	    ;;

	-target-dir=* | --target-dir=* )
	    WORKDIR=`expr "x$option" : "x-*target-dir=\(.*\)"`
	    ;;

	-wipe-existing=* | --wipe-existing=* )
	    WIPEEXISTING=`expr "x$option" : "x-*wipe-existing=\(.*\)"`
	    ;;

	-build-mode=* | --build-mode=* )
	    MODEbuild=`expr "x$option" : "x-*build-mode=\(.*\)"`
	    ;;

	-target-type=* | --target-type=* )
	    MODElib=`expr "x$option" : "x-*target-type=\(.*\)"`
	    ;;

	-with-env-script=* | --with-env-script=* )
	    SETENVscript=`expr "x$option" : "x-*with-env-script=\(.*\)"`
	    ;;

	-rompp-src=* | --rompp-src=* )
	    ROMPPSRC=`expr "x$option" : "x-*rompp-src=\(.*\)"`
	    ;;

	-eigen-path=* | --eigen-path=* )
	    EIGENPATH=`expr "x$option" : "x-*eigen-path=\(.*\)"`
	    ;;

	-gtest-path=* | --gtest-path=* )
	    GTESTPATH=`expr "x$option" : "x-*gtest-path=\(.*\)"`
	    ;;

	-trilinos-path=* | --trilinos-path=* )
	    TRILINOSPATH=`expr "x$option" : "x-*trilinos-path=\(.*\)"`
	    ;;

	-all-tpls-path=* | --all-tpls-path=* )
	    ALLTPLSPATH=`expr "x$option" : "x-*all-tpls-path=\(.*\)"`
	    ;;

	-with-packages=* | --with-packages=* )
	    pkg_list=`expr "x$option" : "x-*with-packages=\(.*\)"`
	    old_IFS=$IFS
	    IFS=,
	    # if list not empty, then reset arrays and append the target libs
	    [ ! -z "$pkg_list" ] && pkg_names=()
	    # loop and store
	    for pkg in $pkg_list; do
		pkg_names=("${pkg_names[@]}" "${pkg}")
	    done
	    IFS=$old_IFS
	    ;;

	# unrecognized option}
	-*)
	    { echo "error: unrecognized option: $option
	  Try \`$0 --help' for more information." >&2
	      { (exit 1); exit 1; }; }
	    ;;

    esac
done


if test "$want_help" = yes; then
  cat <<EOF
\`./main_rompp.sh' build tpls

Usage: $0 [OPTION]...

Defaults for the options are specified in brackets.

Configuration:
-h, --help				display help and exit

--arch=[mac/linux]			set which arch you are using.
					default = NA, must be provided.

--with-packages=list			comma-separated list of ROMPP package names.
					default = core

--target-dir=				the target directory where ROMPP will be build/installed.
					this has to be set, no default provided.
					For example: if you use --target-dir=/home/user,
					and you select core. Then, this script will
					create the following structure:
					/home/uer/rompp/rompp     : contains the source
					/home/uer/rompp/build     : contains the build
					/home/uer/rompp/install   : contains the install

--rompp-src-dir=			the ROMPP source directory
					default = empty, if empty the repo will be cloned
					under the directory set by --target-dir

--eigen-path=				the path to the eigen installation directory
					default = NA, must be set

--gtest-path=				the path to the gtest installation directory
					default = NA, must be set

--trilinos-path=			the path to the trilinos installation directory
					default = NA, must be set

--all-tpls-path=			set this to the dir containing all tpls, if they all
					exist under the same location, e.g. as done by by main_tpls.sh.
					the target dir with all tpls must have same form as created by main_tpls.sh
					if set, then we don't need -eigen-path, -gtest-path, -trilinos-path
					default = empty, either this must be set or all the single ones

--wipe-existing=[0/1]			if true, the build and installation subdirectories of the
					destination folder set by --target-dir will be wiped and remade.
					default = OFF.

--build-mode=[DEBUG/RELEASE]		the build type for each selected tpl.
					default = DEBUG.

--target-type=[dynamic/static]		to build static or dynamic libraries.
					default = shared.

--with-env-script=<path-to-file>	full path to script to set the environment.
					default = assumes environment is set.

EOF
fi

# if help, then exit immediately
test -n "$want_help" && exit 0

# check that all basic variables are set, otherwise leave
if [ -z $ARCH ]; then
    echo "--arch is empty, must be set: exiting"
    exit 0
fi
if [ -z $WORKDIR ]; then
    echo "--target-dir is empty, must be set: exiting"
    exit 0
fi

if [[ -z $ALLTPLSPATH && -z $EIGENPATH && -z $GTESTPATH && -z $TRILINOSPATH ]]; then
    echo "--all-tpls-path is empty, and all individual ones are empty"
    echo "Either you set --all-tpls-path, or each of -eigen-path, -gtest-path, -trilinos-path"
    exit 0
fi

echo "target ROMPP packages to build: ${pkg_names[@]}"

echo "arch = $ARCH"
echo "workdir = $WORKDIR"
echo "wipe = $WIPEEXISTING"
echo "build = $MODEbuild"
echo "lib = $MODElib"
echo "env = $SETENVscript"


#---------------------------------
# step : load modules

if [[ ! -z ${SETENVscript} ]]; then
    echo "setting up environment"
    source ${SETENVscript}
    echo "PATH = $PATH"
fi

#----------------------------------
# step : source helper functions
source help_fncs.sh

#----------------------------------
# step : start building ROMPP

# do build
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

DOBUILD=OFF
[[ -d rompp ]] && check_and_clean rompp || DOBUILD=ON

if [[ $DOBUILD = "ON" ]]; then
    [[ " ${pkg_names[@]} " =~ "core" ]] && buildCORE=ON
    [[ " ${pkg_names[@]} " =~ "qr" ]] && buildQR=ON
    [[ " ${pkg_names[@]} " =~ "solvers" ]] && buildSOLVERS=ON
    [[ " ${pkg_names[@]} " =~ "svd" ]] && buildSVD=ON
    [[ " ${pkg_names[@]} " =~ "ode" ]] && buildODE=ON
    [[ " ${pkg_names[@]} " =~ "rom" ]] && buildROM=ON
fi

is_shared=ON
[[ $MODElib == static ]] && is_shared=OFF
echo "is_shared = $is_shared"
link_search_static=OFF
[[ $MODElib == static ]] && link_search_static=ON

# create dir
[[ ! -d rompp ]] && mkdir rompp
cd rompp

# clone repo
if [ ! -d rompp ]; then
    git clone --recursive git@gitlab.com:fnrizzi/rompp.git
fi
cd rompp && git checkout develop && cd ..

# create build
mkdir build && cd build

# todo: move the cmake command only to a separate place
cmake -D CMAKE_BUILD_TYPE:STRING=$MODEbuild \
      -D CMAKE_INSTALL_PREFIX:PATH=../install \
      -D CMAKE_VERBOSE_MAKEFILE:BOOL=ON \
      \
      -D BUILD_SHARED_LIBS:BOOL=$is_shared \
      -D TPL_FIND_SHARED_LIBS=$is_shared \
      -D Trilinos_LINK_SEARCH_START_STATIC=$link_search_static \
      \
      -D TPL_ENABLE_MPI:BOOL=ON \
      -D MPI_C_COMPILER:FILEPATH=${CC} \
      -D MPI_CXX_COMPILER:FILEPATH=${CXX} \
      -D MPI_EXEC:FILEPATH=${MPIRUNe} \
      -D MPI_USE_COMPILER_WRAPPERS:BOOL=ON \
      \
      -D rompp_ENABLE_CXX11:BOOL=ON \
      -D rompp_ENABLE_SHADOW_WARNINGS:BOOL=OFF \
      -D CMAKE_CXX_FLAGS="-fopenmp" \
      \
      -D TPL_ENABLE_TRILINOS=ON \
      -D TRILINOS_LIBRARY_DIRS="${TRILINOSPATH}/lib64;${TRILINOSPATH}/lib" \
      -D TRILINOS_INCLUDE_DIRS:PATH=${TRILINOSPATH}/include \
      -D TPL_ENABLE_EIGEN=ON \
      -D EIGEN_INCLUDE_DIRS:PATH=${EIGENPATH} \
      -D TPL_ENABLE_GTEST=ON \
      -D GTEST_LIBRARY_DIRS="${GTESTPATH}/lib;${GTESTPATH}/lib64" \
      -D GTEST_INCLUDE_DIRS:PATH=${GTESTPATH}/include \
      \
      -D rompp_ENABLE_Fortran=OFF \
      -D rompp_ENABLE_TESTS:BOOL=ON \
      -D rompp_ENABLE_EXAMPLES:BOOL=OFF \
      -D rompp_ENABLE_ALL_PACKAGES:BOOL=OFF \
      -D rompp_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
      \
      -D rompp_ENABLE_core:BOOL=${buildCORE} \
      -D rompp_ENABLE_qr:BOOL=${buildQR} \
      -D rompp_ENABLE_solvers:BOOL=${buildSOLVERS} \
      -D rompp_ENABLE_svd:BOOL=${buildSVD} \
      -D rompp_ENABLE_ode:BOOL=${buildODE} \
      -D rompp_ENABLE_rom:BOOL=${buildROM} \
      -D DEBUG_PRINT::BOOL=ON \
      \
      ../rompp

make -j 4 install

# return where we started from
cd ${THISDIR}
