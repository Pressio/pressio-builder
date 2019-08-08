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

	-pressio-src=* | --pressio-src=* )
	    PRESSIOSRC=`expr "x$option" : "x-*pressio-src=\(.*\)"`
	    ;;

	-with-cmake-fnc=* | --with-cmake-fnc=* )
	    CMAKELINEGEN=`expr "x$option" : "x-*with-cmake-fnc=\(.*\)"`
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

	-kokkos-path=* | --kokkos-path=* )
	    KOKKOSPATH=`expr "x$option" : "x-*kokkos-path=\(.*\)"`
	    ;;

	-all-tpls-path=* | --all-tpls-path=* )
	    ALLTPLSPATH=`expr "x$option" : "x-*all-tpls-path=\(.*\)"`
	    ;;

	-ncpu-for-make=* | --ncpu-for-make=* )
	    njmake=`expr "x$option" : "x-*ncpu-for-make=\(.*\)"`
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
echo " done parsing cline arguments "
echo ""

if test "$want_help" = yes; then
  cat <<EOF
\`./main_pressio.sh'

Usage: $0 [OPTION]...

Defaults for the options are specified in brackets.

Configuration:
-h, --help				display help and exit

--arch=[mac/linux]			set which arch you are using.
					default = NA, must be provided.

--target-dir=				the target directory where PRESSIO will be build/installed.
					this has to be set, no default provided.
					For example: if you use
					    --target-dir=/home/user,
					then this script will create the following structure:
					    /home/user/pressio/pressio     : contains the source
					    /home/user/pressio/build     : contains the build
					    /home/user/pressio/install   : contains the install

--pressio-src=				the PRESSIO source directory
					default = empty, if empty the repo will be cloned
					under the directory set by --target-dir

--with-packages=list			comma-separated list of PRESSIO package names:
					current pkgs available: mpl, utils, containers, qr, solvers, svd, ode, rom, apps
					If you specify a single package then all other needed
					packages for this are built automatically.
					default = apps

--with-cmake-fnc=			the name of one of the functions inside cmake_line_generator.sh
					This is used to generate the cmake line to configure.
					List of admissible functions is in "cmake_line_generator.sh"
					Currently available (if you add a generic one, make sure
					you list it below. But do not add here those specific to users)
						cee_sparc_basic
						cee_sparc_gcc_tests_on
						cee_sparc_clang_tests_on
						cee_sparc_intel_tests_on
						cee_sparc_cuda_tests_on
						cee_sparc_gcc_tests_off
						cee_sparc_clang_tests_off
						cee_sparc_intel_tests_off
						cee_sparc_cuda_tests_off
						default (try this as first attempt, should work in most cases)
						mrsteam_mpi_alltpls
					default = NA, must be provided

--wipe-existing=[0/1]			if true, the build and installation subdirectories of the
					destination folder set by --target-dir will be wiped and remade.
					default = 1.

--build-mode=[Debug/Release]		the build type for each selected tpl.
					default = Debug

--target-type=[dynamic/static]		to build static or dynamic libraries.
					default = shared.

--with-env-script=<path-to-file>	full path to script to set the environment.
					default = assumes environment is set.

--ncpu-for-make=[n]			number of processes (n) to feed to run: make -j n
					default = 6

To find TPLs:
--eigen-path=				the path to the eigen installation directory
					default = NA, must be set

--gtest-path=				the path to the gtest installation directory
					default = NA, must be set

--trilinos-path=			the path to the (optional) trilinos installation directory
					default = NA, if empty then trilinos is not linked.

--kokkos-path=				the path to the (optional) kokkos installation directory
					default = NA, if empty then kokkos is not linked.

--all-tpls-path=			set this to the directory containing all tpls, if they all
					exist under the same location, e.g. as done by by main_tpls.sh.
					the dir with all tpls must have the structure as obtained by main_tpls.sh
					if you set --all-tpls, you do not need -eigen-path, -gtest-path, -trilinos-path, -kokkos-path.
					default = empty, either this must be set or all the individual ones.

EOF
  exit 0
fi
