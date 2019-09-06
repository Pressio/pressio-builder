#!/usr/bin/env bash

# ORIGDIR will always contain the folder we start from
ORIGDIR=$PWD

# store the platform
ARCH=

# store the working dir
WORKDIR=

# bool to wipe existing content of target directory
WIPEEXISTING=1

# build mode: Debug/Release
MODEbuild=Debug

# build/link shared or static lib
MODElib=shared

# env script
SETENVscript=

# variable to store the bash function that generates the
# cmake string to call for configuring
CMAKELINEGENFNCscript=

# variable to store the cmake string to call for configuring
CMAKELINE=

# needed minimum cmake version
CMAKEVERSIONMIN=3.11.0

# version number of cmake detected
CMAKEVERSIONDETECTED=

# boolean to decide wether we dump all outputs
# from (config, build and install) to files
# if not set, defaults to dumping everything to screen
DUMPTOFILEONLY=0

# boolear [0,1]: if 1, only do dryrun and does not config/build anything
# but it does create folders
DRYRUN=1

# myhostname
MYHOSTNAME=$(hostname)
echo "${fgpurple}My hostname = ${MYHOSTNAME}${fgrst}"

function print_shared_global_vars(){
    echo "ORIGDIR               = $ORIGDIR"
    echo "ARCH                  = $ARCH"
    echo "WORKDIR               = $WORKDIR"
    echo "WIPEEXISTING          = ${WIPEEXISTING}"

    if [ ! -z $MODEbuild ]; then
	echo "MODEbuild             = $MODEbuild"
    else
	echo "MODEbuild             = -"
    fi

    if [ ! -z $MODElib ]; then
	echo "MODElib               = $MODElib"
    else
	echo "MODElib               = -"
    fi

    if [ ! -z $SETENVscript ]; then
	echo "SETENVscript          = $SETENVscript"
    else
	echo "SETENVscript          = -"
    fi

    if [ ! -z $CMAKELINEGENFNCscript ]; then
	echo "CMAKELINEGENFNCscript = $CMAKELINEGENFNCscript"
    else
	echo "CMAKELINEGENFNCscript = -"
    fi

    if [ ! -z $DUMPTOFILEONLY ]; then
	echo "DUMPTOFILEONLY        = $DUMPTOFILEONLY"
    else
	echo "DUMPTOFILEONLY        = -"
    fi
}

function check_minimum_shared_vars_set(){
    if [ -z $ARCH ]; then
	echo "${fgred}--arch is empty, must be set. Terminating. ${fgrst}"
	exit 11
    fi
    if [ -z $WORKDIR ]; then
	echo "${fgred}--target-dir is empty, must be set. Terminating. ${fgrst}"
	exit 12
    fi
}
