#!/usr/bin/env bash

# ORIGDIR will always contain the folder we start from
ORIGDIR=$PWD

# store the platform
if [[ $OSTYPE == *"darwin"* ]]; then
    ARCH=mac
    echo "${fggreen}Detected macOS ${fgrst}"
elif [[ $OSTYPE == *"linux-gnu"* ]]; then
    ARCH=linux
    echo "${fggreen}Detected Linux OS ${fgrst}"
else
    ARCH=
    echo "${fgred}I detected an unknown OS = ${ARCH}. Terminating. ${fgrst}"
    exit 0
fi

# store the working dir
WORKDIR=

# wipe existing content of target directory
WIPEEXISTING=yes

# build mode: Debug/Release
MODEbuild=Debug

# build/link dynamic or static lib
LINKTYPE=dynamic

# env script
SETENVscript=

# variable to store the bash function that generates the
# cmake string to call for configuring
CMAKELINEGENFNCscript=

# variable to store the cmake string to call for configuring
CMAKELINE=

# version number of cmake detected
CMAKEVERSIONDETECTED=

# wether we dump all outputs from (config, build and install) to files
# defaults to dumping everything to screen
DUMPTOFILEONLY=no

# [yes/no] if yes, only do dryrun and does not config/build anything
# but it does create folders and directory tree
DRYRUN=yes

# myhostname
MYHOSTNAME=$(hostname)
echo "${fgpurple}My hostname = ${MYHOSTNAME}${fgrst}"

function print_shared_global_vars(){
    echo "ORIGDIR               = $ORIGDIR"
    echo "Running OS            = $ARCH"
    echo "WORKDIR               = $WORKDIR"
    echo "WIPEEXISTING          = ${WIPEEXISTING}"
    echo "DRYUN                 = ${DRYRUN}"

    if [ ! -z $MODEbuild ]; then
	echo "MODEbuild             = $MODEbuild"
    else
	echo "MODEbuild             = -"
    fi

    if [ ! -z $LINKTYPE ]; then
	echo "LINKTYPE              = $LINKTYPE"
    else
	echo "LINKTYPE              = -"
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
    if [ -z $WORKDIR ]; then
	echo "${fgred}--target-dir is empty, must be set. Terminating. ${fgrst}"
	exit 12
    fi
}
