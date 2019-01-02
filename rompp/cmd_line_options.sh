#!/bin/bash

echo ""
echo "--------------------------------------------"
echo "**parsing cline arguments**"
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

--rompp-src=				the ROMPP source directory
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

# if help, then exit
test -n "$want_help" && exit 0
