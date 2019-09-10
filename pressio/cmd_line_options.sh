#!/bin/bash

echo ""
echo "${fgyellow}+++ parsing cmdline arguments +++${fgrst}"

for option; do
    #echo $option
    case $option in

	-help | --help | -h)
	    want_help=yes
	    ;;

	-dryrun=* | --dryrun=* )
	    DRYRUN=`expr "x$option" : "x-*dryrun=\(.*\)"`
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

	-link-type=* | --link-type=* )
	    MODElib=`expr "x$option" : "x-*link-type=\(.*\)"`
	    ;;

	-env-script=* | --env-script=* )
	    SETENVscript=`expr "x$option" : "x-*env-script=\(.*\)"`
	    ;;

	-pressio-src=* | --pressio-src=* )
	    PRESSIOSRC=`expr "x$option" : "x-*pressio-src=\(.*\)"`
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

	-ncpu-for-make=* | --ncpu-for-make=* )
	    njmake=`expr "x$option" : "x-*ncpu-for-make=\(.*\)"`
	    ;;

	-cmake-custom-generator-file=* | --cmake-custom-generator-file=* )
	    CMAKELINEGENFNCscript=`expr "x$option" : "x-*cmake-custom-generator-file=\(.*\)"`
	    ;;

	-cmake-generator-name=* | --cmake-generator-name=* )
	    CMAKELINEGEN=`expr "x$option" : "x-*cmake-generator-name=\(.*\)"`
	    ;;

	-package-name=* | --package-name=* )
	    PACKAGENAME=`expr "x$option" : "x-*package-name=\(.*\)"`
	    ;;

	# -packages=* | --packages=* )
	#     pkg_list=`expr "x$option" : "x-*packages=\(.*\)"`
	#     old_IFS=$IFS
	#     IFS=,
	#     # if list not empty, then reset arrays and append the target libs
	#     [ ! -z "$pkg_list" ] && pkg_names=()
	#     # loop and store
	#     for pkg in $pkg_list; do
	# 	pkg_names=("${pkg_names[@]}" "${pkg}")
	#     done
	#     IFS=$old_IFS
	#     ;;

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
\`./main_pressio.sh'

Usage: $0 <args>...

NOTE: Does not matter if you prepend Args with - or --, it is the same.
The <args>... can be:

-h, --help				display help and exit

--dryrun=[0/1]				WHAT:	  if dryrun=1, I create the directory tree and print
						  to screen the commands that I would use for configuring/building
					          without performing any real configurantion/build/installation.
						  if dryrun=0, I do the full config/build/installation.
					OPTIONAL: yes
					default   = 1

--pressio-src=				WHAT:	   the FULL path to the Pressio source directory
					OPTIONAL:  yes, if you do not set it, I will clone Pressio and place it
						   inside the directory set by --target-dir

--package-name=				WHAT:	   name of the target pressio package to build.
					CHOICES:   currently: mpl, utils, containers, qr, svd, solvers, ode, rom
					Note:	   Since the packages are interdependent, you do NOT need to specify
						   all of them, so just choose the package you want, then all
						   its dependencies will be turned on and built automatically.
					EXAMPLE:   if you set --package-name=qr, then `mpl, utils, containers` will be also enabled.
					default    = rom (which will enavble all the others)

--target-dir=				WHAT:	   the target directory where Pressio will be built/installed.
					ATTENTION: it must be a full path. I will make the dir if not existing already.
					OPTIONAL:  no, you need to set it, otherwise script exits.
					EXAMPLE:   For example: if you use
							--target-dir=/home/user,
						   then this script will create the following structure:
							/home/user/pressio/build     : contains the build
							/home/user/pressio/install   : contains the install

--wipe-existing=[0/1]			WHAT:	   if = 1, I will delete all the build and installation subdirectories
						   under the destination folder --target-dir and redo things from scratch.
					OPTIONAL:  yes
					default    = 1

--build-mode=[Debug/Release]		WHAT:	   specifies the build type.
					OPTIONAL:  yes
					default    = Debug

--link-type=[dynamic/static]		WHAT:	   what link type to use, static or dynamic libraries.
					OPTIONAL:  yes
					default    = dynamic

--env-script=				WHAT:	   full path to the bash script I will source to set the environment.
					OPTIONAL:  yes, if you don't pass anything, I assume the environment is set.
					NOTE:	   look at the example environment file "script example_env_script.sh"
						   shipped with this repo to find out which environment vars I need.

--ncpu-for-make=[n]			WHAT:	   number of processes (n) to use for parallel make
					OPTIONAL:  yes, if not passed, I will use 6

--cmake-custom-generator-file=		WHAT:	   full path to bash file containing custom functions to generate cmake configure line for Pressio.
						   More specifically, a cmake generator function is supposed to store in the
						   global variable CMAKELINE a string containing the cmake command to configure Pressio.
						   CMAKELINE is simply a string holding the full cmake command you want to use for configuring.
						   CMAKELINE is a global variable that I own.
						   After you overwrite the CMAKELINE, I will execute the command using: ``cmake eval ${CMAKELINE}''.
					OPTIONAL:  yes, not needed if you want to use my default generators.
					EXAMPLE:   look at the example "example_pressio_cmake_generators.sh" shipped with this
						   repo as a reference to see how to build custom ones.
						   To build custom generator functions, you can either use the tpl-specific building blocks
						   pressio/cmake_building_blocks.sh, or (if you know what you are doing) you can
						   just overwriting the CMAKELINE with commands you know.

--cmake-generator-name=			WHAT:	   name of bash function name generating the cmake line string for configuring Pressio.
					OPTIONAL:  yes
					default	   = default
						   List of DEFAULT admissible functions can be found in pressio/cmake_line_generator.sh
					NOTE:	   if you are building pressio with only gtest and eigen as TPLs, using default
						   should (almost) always get you a long way.
						   If building Pressio with Trilinos/Kokkos enabled, then this might not be as smooth.

To specify TPLs (obviously you need to tell me where to find the TPLs that you plan to enable via the cmake generator function):
--eigen-path=				WHAT:	   the full path to eigen installation directory
					OPTIONAL:  no, must be set because pressio requires it

--gtest-path=				WHAT:	   the full path to gtest installation directory
					OPTIONAL:  yes, because it is optional

--trilinos-path=			WHAT:	   the full path to trilinos installation directory
					OPTIONAL:  yes, because it is optional

--kokkos-path=				WHAT:	   the full path to kokkos installation directory
					OPTIONAL:  yes, because it is optional
					NOTE:	   if you set --trilinos-path, I will use the kokkos from there.
						   --kokkos-path is only needed when building Pressio with Kokkos but NOT Trilinos.
EOF
  exit 0
fi
