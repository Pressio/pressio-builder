#!/bin/bash

echo "Bash version ${BASH_VERSION}"

#----------------------------------
# step : define global variables

# PWD will be updated if we change directory
PWD=`pwd`

# THISDIR will always contain the folder we start from
THISDIR=$PWD

# array storing tpl names
declare -a tpl_names=(gtest eigen trilinos)

EIGENCONFIGDIR=${THISDIR}/tpls_config_files
GTESTCONFIGDIR=${THISDIR}/tpls_config_files
TRILINOSCONFIGDIR=${THISDIR}/tpls_config_files/trilinos

# array storing tpl script names
declare -a tpl_scripts=(build_gtest build_eigen	build_trilinos_mpi_kokkos_omp)

# store the working dir
ARCH=

# store the working dir
WORKDIR=

# bool to wipe existing content of target directory
WIPEEXISTING=1

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

	-with-libraries=* | --with-libraries=* )
	    library_list=`expr "x$option" : "x-*with-libraries=\(.*\)"`
	    old_IFS=$IFS
	    IFS=,
	    # if list not empty, then reset arrays and append the target libs
	    [ ! -z "$library_list" ] && tpl_names=()
	    # loop and store
	    for library in $library_list; do
		#LIBS="$LIBS --with-$library"
		tpl_names=("${tpl_names[@]}" "${library}")
	    done
	    IFS=$old_IFS
	    ;;

	-with-scripts=* | --with-scripts=* )
	    script_list=`expr "x$option" : "x-*with-scripts=\(.*\)"`
	    old_IFS=$IFS
	    IFS=,
	    # if list not empty, then reset arrays and append the target libs
	    [ ! -z "$script_list" ] && tpl_scripts=()
	    # loop and store
	    for script in $script_list; do
		tpl_scripts=("${tpl_scripts[@]}" "${script}")
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
\`./main_tpls.sh' build tpls

Usage: $0 [OPTION]...

Defaults for the options are specified in brackets.

Configuration:
-h, --help				display help and exit

--arch=[mac/linux]			set which arch you are using.
					default = NA, must be provided.

--with-libraries=list			comma-separated list of library names. 
					Note that there is no space after commas.
					default = gtest,eigen,trilinos

--with-scripts=list			comma-separated (no space after commas) list of 
					script names to	use to build each tpl. 
					The order should match the one passed to --with-libraries.
					Avaialble scripts must be in rompp_auto_build/tpls_config_files
					default = build_gtest,build_eigen,build_trilinos_mpi_kokkos_omp

--target-dir=				the target directory where the tpls will be build/installed.
					this has to be set, no default provided.
					For example: if you use --target-dir=/home/user/tpls,
					and you select eigen, gtest. Then, this script will
					create the following structure:
					/home/uer/tpls/eigen/eigen     : contains the source
					/home/uer/tpls/eigen/build     : contains the build
					/home/uer/tpls/eigen/install   : contains the install
					/home/uer/tpls/gtest/gtest     : contains the source
					/home/uer/tpls/gtest/build     : contains the build
					/home/uer/tpls/gtest/install   : contains the install

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

echo "target tpls to build: ${tpl_names[@]}"
echo "target tpls to build: ${tpl_scripts[@]}"

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

# check that tpl names are admissible
check_tpl_names

echo "target tpls to build: ${tpl_names[@]}"
echo "target scripts: ${tpl_scripts[@]}"

#----------------------------------
# step : start building tpls

# do build
echo ""
echo "--------------------------------------------"
echo "**building tpls**"
echo ""

build_gtest() {
    local DOBUILD=OFF
    local scriptName=$1
    local myscript=${GTESTCONFIGDIR}/${scriptName}
    echo "script = ${myscript}.sh"
    [[ -d gtest ]] && check_and_clean gtest || DOBUILD=ON
    [[ $DOBUILD = "ON" ]] && bash ${myscript}.sh $ARCH $MODElib
}

build_eigen() {
    local DOBUILD=OFF
    local scriptName=$1
    local myscript=${EIGENCONFIGDIR}/${scriptName}
    echo "script = ${myscript}.sh"
    [[ -d eigen ]] && check_and_clean eigen || DOBUILD=ON
    [[ $DOBUILD = "ON" ]] && bash ${myscript}.sh $ARCH
}

build_trilinos() {
    local DOBUILD=OFF
    local scriptName=$1
    local myscript=${TRILINOSCONFIGDIR}/${scriptName}
    echo "script = ${myscript}.sh"
    [[ -d trilinos ]] && check_and_clean trilinos || DOBUILD=ON
    [[ $DOBUILD = "ON" ]] && bash ${myscript}.sh $MODEbuild $MODElib 4
}

# test is workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# now loop through TPLS and build
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}
    script=${tpl_scripts[i]}
    echo "processing tpl = ${name}"

    [[ ${name} = "gtest" ]] && build_gtest ${script}
    [[ ${name} = "trilinos" ]] && build_trilinos ${script}
    [[ ${name} = "eigen" ]] && build_eigen ${script}
done

# return where we started from
cd ${THISDIR}
