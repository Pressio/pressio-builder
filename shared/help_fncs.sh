#!/usr/bin/env bash

function print_message_dryrun_no(){
    echo ""
    echo "${fgyellow}!!! Since dryrun=no, I am just displaying commands.${fgrst}"
    echo "${fgyellow}!!! If you want to actually conf/build/install, set dryrun=no.${fgrst}"
    echo ""
}

function check_and_clean(){
    local parentdir=$1
    if [ $WIPEEXISTING == yes ];
    then
	if [ ${DRYRUN} == no ]; then
	    echo "wiping ${PWD}/$parentdir/build"
	    echo "wiping ${PWD}/$parentdir/install"
	    rm -rf ${parentdir}/build ${parentdir}/install
	else
	    echo "with dryrun=no, I would wipe ${PWD}/$parentdir/build"
	    echo "with dryrun=no, I would wipe ${PWD}/$parentdir/install"
	fi
	DOBUILD=ON
    else
	echo "${PWD}/$parentdir already exists: skipping"
	echo "If you want to re-build $parentdir, turn wipe-existing=1 and dryrun=0"
    fi
}

function call_env_script(){
    if [[ ! -z ${SETENVscript} ]]; then
	echo ""
	echo "${fgyellow}+++ Loading environment from ${SETENVscript} +++${fgrst}"
	source ${SETENVscript}
	echo "Your PATH = $PATH"
    else
	echo "${fgyellow}+++ --with-env-script is empty. I assume env is set +++${fgrst}"
    fi
}

function version {
    echo "$@" | awk -F. '{ printf("%d%02d%02d\n", $1,$2,$3); }';
}

function detect_cmake(){
    # check if cmake is found in PATH
    if [ -x "$(command -v cmake)" ]; then
	CMAKEVERSIONDETECTED="$(cmake --version | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')"
    fi
}

function have_admissible_cmake(){
    # detect cmake
    detect_cmake
    echo ""
    echo "${fgyellow}+++ Detecting which cmake you have +++${fgrst}"
    echo "CMAKEVERSIONDETECTED=$CMAKEVERSIONDETECTED"

    if [ -z $CMAKEVERSIONDETECTED ]; then
	# if cmakeversion is empty
	echo "${fgred}No Cmake found. Terminating. ${fgrst}"
	exit 15
    else
	# if cmakeversion is NOT empty but wrong version
    	if [ $(version $CMAKEVERSIONDETECTED) -lt $(version "$CMAKEVERSIONMIN") ]; then
	    echo "${fgred}You have cmake ${CMAKEVERSIONDETECTED} ${fgrst}"
	    echo "${fgred}while I need >=${CMAKEVERSIONMIN}. Terminate.${fgrst}"
    	    exit 15
    	else
	    return 0
    	fi
    fi
}
