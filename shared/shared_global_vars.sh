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
WIPEEXISTING=no

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
echo "${fggreen}Detected hostname: ${MYHOSTNAME}${fgrst}"
