#!/usr/bin/env bash

echo ""
echo "${fgyellow}+++ parsing cmdline arguments +++${fgrst}"

for option; do
    echo $option
    case $option in
	# print help
	-help | --help | -h)
	    want_help=yes
	    ;;

	-dryrun=* | --dryrun=* )
	    DRYRUN=`expr "x$option" : "x-*dryrun=\(.*\)"`
	    ;;

	-tpls=* | --tpls=* )
	    library_list=`expr "x$option" : "x-*tpls=\(.*\)"`
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

	-print-logs-to-file-only=* | --print-logs-to-file-only=* )
	    DUMPTOFILEONLY=`expr "x$option" : "x-*print-logs-to-file-only=\(.*\)"`
	    ;;

	-env-script=* | --env-script=* )
	    SETENVscript=`expr "x$option" : "x-*env-script=\(.*\)"`
	    ;;

	-cmake-custom-generator-file=* | --cmake-custom-generator-file=* )
	    CMAKELINEGENFNCscript=`expr "x$option" : "x-*cmake-custom-generator-file=\(.*\)"`
	    ;;

	-cmake-generator-names=* | --cmake-generator-names=* )
	    fncs_list=`expr "x$option" : "x-*cmake-generator-names=\(.*\)"`
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
#echo "${fgyellow}+++ done with cmdline arguments +++${fgrst}"


if test "$want_help" = yes; then
  cat <<EOF
\`./main_tpls.sh' build tpls

Usage: $0 <args>...

NOTE: Does not matter if you prepend Args with - or --, it is the same.
The <args>... can be:

-h, --help				display help and exit

--dryrun=[0/1]				WHAT:	  if dryrun=1, I create the target directory tree and print
						  to screen the commands that I would use for configuring/building
					          without performing any real configurantion/build/installation
					OPTIONAL: yes
					default   = 1

--tpls=					WHAT:	   comma-separated list of the library names to build.
					ATTENTION: there is no space after commas.
					CHOICES:   currently, eigen,gtest,pybind11,trilinos,kokkos
					Note:	   if building trilinos with kokkos, no need to build kokkos separately
						   because the trilinos I build has Kokkos enabled
					OPTIONAL:  yes
					default    = gtest,eigen

--target-dir=				WHAT:	   the target directory where I will build/install all tpls.
					ATTENTION: you must provide a full path
					OPTIONAL:  no, you MUST set it, otherwise script exits.
					EXAMPLE:   if you use:
							--target-dir=/home/user/tpls
						   and you set
							--with-libraries=gtest,eigen
						   then I will create a structure like so:
							/home/user/tpls/gtest/gtest     : contains the gtest source
							/home/user/tpls/gtest/build     : contains the gtest build
							/home/user/tpls/gtest/install   : contains the gtest install
							/home/user/tpls/eigen/eigen     : contains the eigen source
							/home/user/tpls/eigen/build     : contains the eigen build
							/home/user/tpls/eigen/install   : contains the eigen install

--wipe-existing=[0/1]			WHAT:	   if = 1, I will delete all the build and installation subdirectories
						   under the destination folder --target-dir and redo things from scratch.
					OPTIONAL:  yes
					default    = 1

--build-mode=[Debug/Release]		WHAT:	   specifies the build type for each selected tpl.
					Note:	   build-mode not used for eigen,gtest,pybind11: these are header only.
						   build-mode is used for trilinos/kokkos.
					OPTIONAL:  yes
					default    = Debug

--link-type=[dynamic/static]		WHAT:	   what link type to use, static or dynamic libraries.
					OPTIONAL:  yes
					default    = dynamic

--print-logs-to-file-only=[0/1]		WHAT:	   if =1, I will print all configure/build/install logs, to files
						   that are specific for each TPL built and I will NOT print anything to screen.
						   if =0, I will both print to files and to screen.
					OPTIONAL:  yes
					default    = 0

--env-script=				WHAT:	   full path to the bash script I will source to set the environment.
					OPTIONAL:  yes, if you don't pass anything, I assume the environment is set.
					NOTE:	   look at the example environment file "script example_env_script.sh"
						   shipped with this repo to find out which environment vars I need.

--cmake-custom-generator-file=		WHAT:	   full path to bash file containing custom functions to generate cmake configure lines for tpls.
						   More specifically, a cmake generator function is supposed to store in the
						   global variable CMAKELINE a string containing the cmake command to configure a specific tpl.
						   CMAKELINE is simply a string holding the full cmake command you want to use for configuring a tpl.
						   CMAKELINE is a global variable that I own, and since I build TPLs sequentially,
						   every time a new tpl needs to be built, the CMAKELINE is reset. So in your custom generators
						   you can assume that on entry, CMAKELINE is empty.
						   After you overwrite the CMAKELINE, I will execute the command using: ``cmake eval ${CMAKELINE}''.
					OPTIONAL:  yes, not needed if you want to use my default generators.
					EXAMPLE:   look at the example "example_tpls_cmake_generators.sh" shipped with this
						   repo as a reference to see how to build custom ones.
						   To build custom generator functions, you can either use the tpl-specific building blocks
						   <tplname>_cmake_lines/cmake_building_blocks.sh, or (if you know what you are doing) you can
						   just overwriting the CMAKELINE with commands you know.

--cmake-generator-names=		WHAT:	   comma-separated list of bash function names generating the cmake line string for configuring.
					ATTENTION: there is no space after commas.
					ATTENTION: The order of the names should match the list passed to --with-libraries.
						   If you pass a custom file to -cmake-generators-file, then the function names passed in
						   cmake-generators-names can be taken from those in that custom bash file.
					OPTIONAL:  yes
					default	   = default,default
						   List of DEFAULT admissible functions can be found in <tplname>_cmake_lines/cmake_line_generator.sh
					NOTE:	   for eigen,gtest,pybind using the default should (almost) always be successful.
						   For Trilinos and Kokkos things are more complex, so default might not work straight out of the box.

EOF
  exit 0
fi
