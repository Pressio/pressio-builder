#!/usr/bin/env bash

echo ""
echo "${fgyellow}+++ Parsing cmdline arguments +++${fgrst}"

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
	    {
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
	    }
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
	    LINKTYPE=`expr "x$option" : "x-*link-type=\(.*\)"`
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


if test "$want_help" = yes; then
  cat <<EOF
\`./main_tpls.sh' build tpls

Usage: $0 <args>...

-h, --help				display help and exit

--dryrun=[yes/no]			WHAT:	  if dryrun=yes, I create the target directory tree and print
						  to screen the commands that I would use for configuring/building
					          without performing any real configurantion/build/installation
					OPTIONAL: yes
					default   = yes

--tpls=					WHAT:	   comma-separated list of the library names to build.
					CHOICES:   gtest,eigen,pybind11,trilinos,kokkos
					ATTENTION: do not put a space after the commas
					Note:	   if you build trilinos with one of the default settings, no need
						   to build kokkos separately because I build trilinos with Kokkos enabled
					OPTIONAL:  yes
					default    = gtest,eigen,pybind11,trilinos

--target-dir=				WHAT:	   the target directory where I will build/install all tpls.
					ATTENTION: you must provide a full path
					OPTIONAL:  no. You MUST set it, otherwise script terminates.
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

--env-script=				WHAT:	   full path to the bash script I will source to set the environment.
					OPTIONAL:  yes, if you don't pass anything, I assume the environment is set.
					NOTE:	   look at the example environment file "script example_env_script.sh"
						   shipped with this repo to find out which environment vars I need.

--build-mode=[Debug/Release]		WHAT:	   specifies the build type for each selected tpl.
					Note:	   build-mode is NOT used for eigen,gtest,pybind11: these are header only.
						   build-mode is used for trilinos and kokkos.
					OPTIONAL:  yes
					default    = Debug

--wipe-existing=[yes/no]		WHAT:	   if yes, I will delete all the build and installation subdirectories
						   under the destination folder --target-dir and redo things from scratch.
					OPTIONAL:  yes
					default    = no

--link-type=[dynamic/static]		WHAT:	   what link type to use, static or dynamic libraries.
					OPTIONAL:  yes
					default    = dynamic

--cmake-custom-generator-file=		WHAT:	   full path to bash file containing custom functions to generate cmake configure lines for tpls.
						   A cmake generator function is supposed to store in the global variable CMAKELINE a string
						   containing the cmake command to configure a specific tpl.
						   CMAKELINE is simply a string holding the full cmake command you want to use for configuring a tpl.
						   CMAKELINE is a global variable that I own, and since I build TPLs sequentially,
						   every time a new tpl needs to be built, the CMAKELINE is reset. So in your custom generators
						   you can assume that on entry, CMAKELINE is empty.
						   After you overwrite the CMAKELINE, I will execute the command using: ``cmake eval ${CMAKELINE}''.
					OPTIONAL:  yes, you can use one of my default generators.
					EXAMPLE:   To build custom generator functions, you can either use the tpl-specific building blocks
						   pressio-builder/tpls/all/<tplname>/cmake_building_blocks.sh, or (if you know what you are doing) you can
						   just overwrite the CMAKELINE with commands you know.

--cmake-generator-names=		WHAT:	   comma-separated list of bash function names generating the cmake line string for configuring.
					ATTENTION: there is no space after commas.
					ATTENTION: The order of the names should match the list passed to --tpls.
						   If you pass a custom file to -cmake-generators-file, then the function names passed in
						   cmake-generators-names can be taken from those in that custom bash file.
					OPTIONAL:  yes
					default	   = default,default,default,default
						   List of DEFAULT admissible functions can be found in <tplname>_cmake_lines/default_cmake_line_generator.sh
					NOTE:	   for eigen,gtest,pybind using the default should (almost) always be successful.
						   For Trilinos and Kokkos things are more complex, you can try the default and in most
						   cases it should work, but it might not work straight out of the box.

EOF
  exit 0
fi
