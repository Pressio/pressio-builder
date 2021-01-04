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

	-target-repo=* | --target-repo=* )
	    WORKDIR=`expr "x$option" : "x-*target-repo=\(.*\)"`
	    ;;

	-mcss-path=* | --mcss-path=* )
	    MCSSPATH=`expr "x$option" : "x-*mcss-path=\(.*\)"`
	    ;;

	-wipe-existing=* | --wipe-existing=* )
	    WIPEEXISTING=`expr "x$option" : "x-*wipe-existing=\(.*\)"`
	    ;;

	-env-script=* | --env-script=* )
	    SETENVscript=`expr "x$option" : "x-*env-script=\(.*\)"`
	    ;;

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

-h, --help				display help and exit

--dryrun=[yes/no]			WHAT:	   if dryrun=yes, nothing is built, just showing commands.
					OPTIONAL:  yes
					default    = yes

--target-repo=				WHAT:	   full path to repo to build website for.
					ATTENTION: it must be a full path.
					OPTIONAL:  no, you need to set it, otherwise script exits.

--mcss-path=				WHAT:	   full path to mcss repo
					ATTENTION: it must be a full path.
					OPTIONAL:  no, you need to set it, otherwise script exits.

--wipe-existing=[yes/no]		WHAT:	   if yes, I will delete all the build and installation subdirectories
						   under the destination folder --target-dir and redo things from scratch.
					OPTIONAL:  yes
					default    = yes

--env-script=				WHAT:	   full path to the bash script I will source to set the environment.
					OPTIONAL:  yes, if you don't pass anything, I assume the environment is set.
EOF
  exit 0
fi
