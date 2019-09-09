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

	-pressio-tutorials-src=* | --pressio-tutorials-src=* )
	    PRESSIOTUTORIALSSRC=`expr "x$option" : "x-*pressio-tutorials-src=\(.*\)"`
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

	-env-script=* | --env-script=* )
	    SETENVscript=`expr "x$option" : "x-*env-script=\(.*\)"`
	    ;;

	-eigen-path=* | --eigen-path=* )
	    EIGENPATH=`expr "x$option" : "x-*eigen-path=\(.*\)"`
	    ;;

	-pressio-path=* | --pressio-path=* )
	    PRESSIOPATH=`expr "x$option" : "x-*pressio-path=\(.*\)"`
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

--pressio-tutorials-src=		WHAT:	   the FULL path to the pressio-tutorials source directory.
					OPTIONAL:  yes, if you do not set it, I will clone it and place it.
						   inside the directory set by --target-dir

--target-dir=				WHAT:	   the target directory where pressio-tutorials will be built.
					ATTENTION: it must be a full path. I will make the dir if not existing already.
					OPTIONAL:  no, you need to set it, otherwise script exits.
					EXAMPLE:   For example: if you use
							--target-dir=/home/user,
						   then this script will create the following structure:
							/home/user/pressio-tutorials/build     : contains the build

--wipe-existing=[0/1]			WHAT:	   if = 1, I will delete all the build and installation subdirectories
						   under the destination folder --target-dir and redo things from scratch.
					OPTIONAL:  yes
					default    = 1

--build-mode=[Debug/Release]		WHAT:	   specifies the build type.
					OPTIONAL:  yes
					default    = Debug

--env-script=				WHAT:	   full path to the bash script I will source to set the environment.
					OPTIONAL:  yes, if you don't pass anything, I assume the environment is set.
					NOTE:	   look at the example environment file "script example_env_script.sh"
						   shipped with this repo to find out which environment vars I need.

--eigen-path=				WHAT:	   the full path to eigen installation directory.
					OPTIONAL:  no, must be set because pressio-tutorials requires it

--pressio-path=				WHAT:	   the full path to pressio installation directory.
					OPTIONAL:  no, must be set because pressio-tutorials requires it

EOF
  exit 0
fi
