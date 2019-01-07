#!/bin/bash

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
		tpl_names=("${tpl_names[@]}" "${library}")
	    done
	    IFS=$old_IFS
	    ;;

	-with-cmake-line-fncs=* | --with-cmake-line-fncs=* )
	    fncs_list=`expr "x$option" : "x-*with-cmake-line-fncs=\(.*\)"`
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

--with-cmake-line-fncs=list		comma-separated (no space after commas) list of
					functions' names to use to generate the cmake line
					for configuring each tpl.
					The order should match the one passed to --with-libraries.
					The admissible functions can be found in <libname>_cmake_lines
					default = default,default,default

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
					default = dynamic

--with-env-script=<path-to-file>	full path to script to set the environment.
					default = assumes environment is set.

EOF
fi

# if help, then exit
test -n "$want_help" && exit 0





# --with-cmake-fncs=list			comma-separated (no space after commas) list of
# 					script names to	use to build each tpl.
# 					The order should match the one passed to --with-libraries.
# 					Avaialble scripts must be in rompp_auto_build/tpls_config_files
# 					default = build_gtest,build_eigen,build_trilinos_mpi_kokkos_omp
