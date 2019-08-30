#!/bin/bash

function check_and_clean(){
    echo "chec clean"

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
    echo "call env"

    if [[ ! -z ${SETENVscript} ]]; then
	echo "loading environment from ${SETENVscript}"
	source ${SETENVscript}
	echo "PATH = $PATH"
    else
	echo "--with-env-script NOT set, so we assume env is set already"
    fi
}

function is_cee_build_machine(){
    myname=$(hostname)
    echo "my hostname ${myname}"
    if [ $myname == *"cee-build"* ]; then
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
    echo "CMAKEVERSIONDETECTED=$CMAKEVERSIONDETECTED"

    # if cmakeversion is empty
    if [ -z $CMAKEVERSIONDETECTED ]; then
	echo "No Cmake found"
	return 1
    else
    	if [ $(version $CMAKEVERSIONDETECTED) -lt $(version "$CMAKEVERSIONMIN") ]; then
	    echo "you have cmake ${CMAKEVERSIONDETECTED} while I need >=${CMAKEVERSIONMIN}"
    	    return 1
    	else
	    echo "found good cmake"
	    return 0
    	fi
    fi
}
