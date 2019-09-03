#!/bin/bash

echo ""
echo "${fgyellow}+++ parsing cmdline arguments +++${fgrst}"

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
		tpl_names=("${tpl_names[@]}" "${library}")
	    done
	    IFS=$old_IFS
	    ;;

	-with-cmake-gen-function-file=* | --with-cmake-gen-function-file=* )
	    CMAKELINEGENFNCscript=`expr "x$option" : "x-*with-cmake-gen-function-file=\(.*\)"`
	    ;;

	-with-cmake-gen-function-names=* | --with-cmake-gen-function-names=* )
	    fncs_list=`expr "x$option" : "x-*with-cmake-gen-function-names=\(.*\)"`
	    old_IFS=$IFS
	    IFS=,
	    # if list not empty, then reset arrays and append the target libs
	    [ ! -z "$fncs_list" ] && tpl_cmake_fncs=()
	    # loop and store
	    for ifnc in $fncs_list; do
		tpl_cmake_fncs=("${tpl_cmake_fncs[@]}" "${ifnc}")
	    done
	    IFS=$old_IFS
	    ;;

	-dump-to-file-only=* | --dump-to-file-only=* )
	    DUMPTOFILEONLY=`expr "x$option" : "x-*dump-to-file-only=\(.*\)"`
	    ;;

	-dryrun=* | --dryrun=* )
	    DRYRUN=`expr "x$option" : "x-*dryrun=\(.*\)"`
	    ;;

	# unrecognized option}
	-*)
	    { echo "error: unrecognized option: $option
	  Try \`$0 --help' for more information." >&2
	      { (exit 1); exit 1; }; }
	    ;;

    esac
done
#echo "${fgyellow}+++ done with cmdline arguments +++${fgrst}"


if test "$want_help" = yes; then
  cat <<EOF
\`./main_tpls.sh' build tpls

Usage: $0 [OPTION]...

Defaults for the options are specified in brackets.

Configuration:
-h, --help				display help and exit

--arch=[mac/linux]			set which arch you are using.
					default = NA, must be provided.

--dryrun=[0/1]				if =1, creates all directories and prints string
					for configuring but does NOT perform any configurantion/build/installation
					default = 1

--with-libraries=list			comma-separated list of library names.
					NOTE: there is no space after commas.
					default = gtest,eigen,trilinos,kokkos,pybind11
					Note: if building trilinos with kokkos, no need to build kokkos separately
					because the trilinos version build by this script has Kokkos enabled

--target-dir=				the target directory where the tpls are built/installed.
					this has to be set, no default is provided.
					For example: if you use
					    --target-dir=/home/user/tpls
					and you select eigen, gtest, then this script will
					create a structure like so:
					    /home/user/tpls/eigen/eigen     : contains the source
					    /home/user/tpls/eigen/build     : contains the build
					    /home/user/tpls/eigen/install   : contains the install
					    /home/user/tpls/gtest/gtest     : contains the source
					    /home/user/tpls/gtest/build     : contains the build
					    /home/user/tpls/gtest/install   : contains the install

--wipe-existing=[0/1]			if =1 (true), the build and installation subdirectories of the
					destination folder set by --target-dir will be wiped and remade.
					default = 1.

--build-mode=[Debug/Release]		the build type for each selected tpl.
					NOTE: Debug/Release do not apply to eigen,gtest or pybind11 since
					these are header only libraries.
					BUt Debug/Release are used for trilinos/kokkos.
					DEFAULT = Debug

--target-type=[dynamic/static]		to build static or dynamic libraries.
					default = dynamic

--dump-to-file-only=[0/1]		if =1 (true), dumps all outputs from config, build and install to files
					that are specific for each TPL built and does not print anything to screen
					default = 0

--with-env-script=<path-to-file>	full path to script to set the environment.
					NOTE: look at the template environment script shipped with
					this repo to find out which env vars are needed.
					default = assumes environment is set.

--with-cmake-gen-function-file=<path-to-file>	full path to bash file containing custom functions
					to generate cmake configure lines.
					These functions can be built by referring to
					the cmake_building_block.sh inside <libname>_cmake_lines.

--with-cmake-gen-functions-names=list	comma-separated (no space after commas) list of func
					names generating the cmake line	for configuring each tpl.
					The order of these names should match the list passed to --with-libraries.
					If you pass a bash file to -with-cmake-gen-function-file defining
					custom functions, then the name can be one of those in that bash script.
					List of DEFAULT admissible functions can be found in the file
					"cmake_line_generator.sh" inside <libname>_cmake_lines.
						eigen: default
						gtest: default
						trilinos: default
						kokkos: default
						pybind11: default
					NOTE: while for eigen,gtest,pybind you should always be successful
					by simply using the ''default'' nane, trilinos and Kokkos are more complex.
					So default might not work straight out of the box.

					default = default,default,default,default,default

EOF
  exit 0
fi
