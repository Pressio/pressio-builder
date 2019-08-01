#!/bin/bash

# THISDIR will always contain the folder we start from
THISDIR=$PWD

# store the working dir
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

# the var to store the cmake line to configure
CMAKELINE=


print_shared_global_vars(){
    echo "THISDIR        = $THISDIR"
    echo "ARCH           = $ARCH"
    echo "WORKDIR        = $WORKDIR"
    echo "WIPEEXISTING   = ${WIPEEXISTING}"
    echo "MODEbuild      = $MODEbuild"
    echo "MODElib        = $MODElib"
    echo "SETENVscript   = $SETENVscript"
}

check_minimum_shared_vars_set(){
    if [ -z $ARCH ]; then
	echo "--arch is empty, must be set: exiting"
	exit 0
    fi
    if [ -z $WORKDIR ]; then
	echo "--target-dir is empty, must be set: exiting"
	exit 0
    fi
}
