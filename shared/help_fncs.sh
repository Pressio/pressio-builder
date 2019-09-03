#!/usr/bin/env bash

function check_and_clean(){
    local parentdir=$1
    if [ $WIPEEXISTING -eq 1 ]; then
	echo "within ${PWD}"
	echo "wiping $parentdir/build"
	echo "wiping $parentdir/install"
	rm -rf ${parentdir}/build ${parentdir}/install
	DOBUILD=ON
    else
	echo "$parentdir exists: skipping"
	exit 0
    fi
}

function call_env_script(){
    if [[ ! -z ${SETENVscript} ]]; then
	echo "${fgyellow}+++ Loading environment from ${SETENVscript} +++{$fgrst}"
	source ${SETENVscript}
	echo "PATH = $PATH"
    else
	echo "${fgyellow}+++ --with-env-script is empty. I assume env is set +++${fgrst}"
    fi
}

function is_cee_build_machine(){
    if [ ${MYHOSTNAME} == *"cee-build"* ]; then
	return 1
    else
	return 0
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
    detect_cmake
    echo ""
    echo "${fgyellow}+++ Detecting which cmake you have +++${fgrst}"
    echo "CMAKEVERSIONDETECTED=$CMAKEVERSIONDETECTED"

    # if cmakeversion is empty
    if [ -z $CMAKEVERSIONDETECTED ]; then
	echo "${fgred} No Cmake found. Terminating. ${fgrst}"
	return 1
    else
    	if [ $(version $CMAKEVERSIONDETECTED) -lt $(version "$CMAKEVERSIONMIN") ]; then
	    echo "${fgred}You have cmake ${CMAKEVERSIONDETECTED} ${fgrst}"
	    echo "${fgred}while I need >=${CMAKEVERSIONMIN}. Terminating. ${fgrst}"
    	    return 1
    	else
	    return 0
    	fi
    fi
}
