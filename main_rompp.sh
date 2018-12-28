#!/bin/bash

echo "Bash version ${BASH_VERSION}"

#---------------------------------
# step : global variables

# PWD will be updated if we change directory
PWD=`pwd`

# THISDIR will always contain the folder we start from
THISDIR=$PWD

# array storing packages
declare -a pkg_names=(core)

# path to dir where eigen is installed
EIGENPATH=
# path to dir where gtest is installed
GTESTPATH=
# path to dir where trilinos is installed
TRILINOSPATH=
# path to dir where all tpls are installed
# structure must follow what main_tpls.sh does
ALLTPLSPATH=

# rompp git repo src
ROMPPSRC=

# name of the cmake configuring line
CMAKECONFIGfnc=cmake_rompp_mpi_omp

# the working dir
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

echo ""
echo "****************************************************************************************"
echo " default global vars "
echo "****************************************************************************************"
echo ""

print_env_vars(){
    echo "THISDIR        = $THISDIR"
    echo "pkg_names      = ${pkg_names[@]}"
    echo "EIGENPATH      = $EIGENPATH"
    echo "GTESTPATH      = $GTESTPATH"
    echo "TRILINOSPATH   = $TRILINOSPATH"
    echo "ALLTPLSPATH    = $ALLTPLSPATH"
    echo "ROMPPSRC       = $ROMPPSRC"
    echo "CMAKECONFIGfnc = $CMAKECONFIGfnc"
    echo "ARCH           = $ARCH"
    echo "WORKDIR        = $WORKDIR"
    echo "WIPEEXISTING   = ${WIPEEXISTING}"
    echo "MODEbuild      = $MODEbuild"
    echo "MODElib        = $MODElib"
    echo "SETENVscript   = $SETENVscript"
}
print_env_vars


echo ""
echo "****************************************************************************************"
echo " parsing cline arguments "
echo ""

for option; do
    #echo $option
    case $option in

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

	-with-cmake-fnc=* | --with-cmake-fnc=* )
	    CMAKECONFIGfnc=`expr "x$option" : "x-*with-cmake-fnc=\(.*\)"`
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
# echo ""
# echo " done parsing cline arguments "
# echo "****************************************************************************************"
# echo ""

if test "$want_help" = yes; then
  cat <<EOF
\`./main_rompp.sh'

Usage: $0 [OPTION]...

Defaults for the options are specified in brackets.

Configuration:
-h, --help				display help and exit

--arch=[mac/linux]			set which arch you are using.
					default = NA, must be provided.

--target-dir=				the target directory where ROMPP will be build/installed.
					this has to be set, no default provided.
					For example: if you use --target-dir=/home/user,
					then this script will create the following structure:
					/home/uer/rompp/rompp     : contains the source
					/home/uer/rompp/build     : contains the build
					/home/uer/rompp/install   : contains the install

--rompp-srcr=				the ROMPP source directory
					default = empty, if empty the repo will be cloned
					under the directory set by --target-dir

--with-packages=list			comma-separated list of ROMPP package names:
					the current pacakges available: core, qr, solvers, svd, ode, rom
					default = core.

--with-cmake-fnc=			a name of one of the functions inside 'rompp_cmake_lines.sh'
					default = cmake_rompp_mpi_omp

--wipe-existing=[0/1]			if true, the build and installation subdirectories of the
					destination folder set by --target-dir will be wiped and remade.
					default = OFF.

--build-mode=[DEBUG/RELEASE]		the build type for each selected tpl.
					default = DEBUG.

--target-type=[dynamic/static]		to build static or dynamic libraries.
					default = shared.

--with-env-script=<path-to-file>	full path to script to set the environment.
					default = assumes environment is set.

To find TPLs:
--eigen-path=				the path to the eigen installation directory
					default = NA, must be set

--gtest-path=				the path to the gtest installation directory
					default = NA, must be set

--trilinos-path=			the path to the trilinos installation directory
					default = NA, must be set

--all-tpls-path=			set this to the dir containing all tpls, if they all
					exist under the same location, e.g. as done by by main_tpls.sh.
					the dir with all tpls must have same form as created by main_tpls.sh
					if set, then we don't need -eigen-path, -gtest-path, -trilinos-path
					default = empty, either this must be set or all the single ones

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

# print variables at this point
echo "the env variables currently set are"
print_env_vars


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
