#!/bin/bash

echo "Bash version ${BASH_VERSION}"

#----------------------------------
# step : test cline arguments

n_args=$#
if test $n_args -lt 10
then
    str="[linux/mac] "
    str+="<working-dir-full-path> "
    str+="[wipe_existing=0/1]"
    str+="[DEBUG/RELEASE] [dynamic/static] "
    str+="<full-path-to-setenv.sh> "
    str+="[rompp_script_name] "
    str+="[eigen] <eigen_full_path> "
    str+="[gtest] <gtest_full_path> "
    str+="[trilinos] <trilinos_full_path> "

    echo "usage:"
    echo "$0 $str"
    exit 1;
fi

#----------------------------------
# step : define global variables

# PWD will be updated if we change directory
PWD=`pwd`
# BASEDIR will always contain the folder we start from
BASEDIR=$PWD

ROMPPCONFIGDIR=${BASEDIR}/rompp_config_files

declare -a tpl_names   # array tpl names
declare -a tpl_paths   # array tpl paths

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

# env script
SETENVscript=$6

# script name for rompp build
ROMPPSCRIPT=$7 && echo "rompp script name: ${ROMPPSCRIPT}"

# store all tpl names
for (( i=8; i<=$n_args-1; i+=2 ))
do
    # path comes after tpl name
    j=$((i+1))

    # append to arrays
    tpl_names=("${tpl_names[@]}" "${!i}")
    tpl_paths=("${tpl_paths[@]}" "${!j}")
done

echo "target tpls to build: ${tpl_names[@]}"
echo "target paths: ${tpl_paths[@]}"

#---------------------------------
# step : load modules

echo "setting up environment"
source ${SETENVscript}
echo "PATH = $PATH"

#----------------------------------
# step : source helper functions
source help_fncs.sh

#----------------------------------
# step : start building rompp

build_rompp() {
    scriptname=${ROMPPCONFIGDIR}/${ROMPPSCRIPT}
    local DOBUILD=OFF
    local TRILINOS_PATH=/
    local EIGEN_PATH=/
    local GTEST_PATH=/
    for ((i=0;i<${#tpl_names[@]};++i)); do
        name=${tpl_names[i]}
        currpath=${tpl_paths[i]}
        [[ $name = "trilinos" ]] && TRILINOS_PATH=${currpath}
        [[ $name = "eigen" ]] && EIGEN_PATH=${currpath}
        [[ $name = "gtest" ]] && GTEST_PATH=${currpath}
    done
    echo $TRILINOS_PATH
    echo $EIGEN_PATH
    echo $GTEST_PATH

    [[ -d romppdir ]] && check_and_clean romppdir || DOBUILD=ON
    if [ $DOBUILD = "ON" ]; then
        bash ${scriptname}.sh $MODEbuild $MODElib 4 ${EIGEN_PATH} ${GTEST_PATH} ${TRILINOS_PATH}
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

build_rompp

# return where we started from
cd $BASEDIR
