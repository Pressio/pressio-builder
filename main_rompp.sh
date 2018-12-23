#!/bin/bash

echo "Bash version ${BASH_VERSION}"

#----------------------------------
# step : test cline arguments

n_args=$#
if test $n_args -lt 7
then
    str="[linux/mac] "
    str+="<working-dir-full-path> "
    str+="[wipe_existing=0/1]"
    str+="[DEBUG/RELEASE] [dynamic/static] "
    str+="[rompp_script_name] "
    str+="[tpls_path] "

    echo "usage:"
    echo "$0 $str"
    exit 1;
fi

#---------------------------------
# step : load modules

echo "setting up environment"
source setenv.sh
echo "PATH = $PATH"

#----------------------------------
# step : define global variables

# PWD will be updated if we change directory
PWD=`pwd`
# BASEDIR will always contain the folder we start from
BASEDIR=$PWD

ROMPPCONFIGDIR=${BASEDIR}/rompp_config_files

#----------------------------------
# step : parse cline arguments

echo ""
echo "--------------------------------------------"
echo "**parsing cline arguments**"
echo ""

# store the working dir
ARCH=$1 && echo "arch = $ARCH"

# store the working dir
WORKDIR=$2 && echo "workdir = $WORKDIR"

# bool to wipe existing content of target directory
WIPEEXISTING=$3

# build mode
MODEbuild=$4 && echo "you selected: $MODEbuild"

# build/link shared or static lib
MODElib=$5 && echo "you selected: $MODElib"

# script name for rompp build
ROMPPSCRIPT=$6 && echo "rompp script name: ${ROMPPSCRIPT}"

# path to TPLS
TPLSPATH=$7 && echo "path to tpls: ${TPLSPATH}"


#----------------------------------
# step : source helper functions
source help_fncs.sh


#----------------------------------
# step : start building rompp

build_rompp() {
    local DOBUILD=OFF
    local scriptName=$1
    [[ -d romppdir ]] && check_and_clean romppdir || DOBUILD=ON

    if [ $DOBUILD = "ON" ]; then
	bash ${ROMPPCONFIGDIR}/${scriptName}.sh $MODEbuild $MODElib 4 $TPLSPATH
    fi
}
# test is workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# do build
echo ""
echo "--------------------------------------------"
echo "**building rompp**"
echo ""
echo "using script = ${ROMPPCONFIGDIR}/${ROMPPSCRIPT}.sh"

build_rompp ${ROMPPSCRIPT}

# return where we started from
cd $BASEDIR
