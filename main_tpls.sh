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
    str+="[libname1] [lib1_script_name] "
    str+="[libname2] [lib2_script_name] "

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

EIGENCONFIGDIR=${BASEDIR}/tpls_config_files/eigen
GTESTCONFIGDIR=${BASEDIR}/tpls_config_files/gtest
TRILINOSCONFIGDIR=${BASEDIR}/tpls_config_files/trilinos


declare -a tpl_names     # array tpl names
declare -a tpl_scripts   # array tpl script names

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

# store all tpl names
for (( i=6; i<=$n_args-1; i+=2 ))
do
    # config file name comes after tpl name
    j=$((i+1))

    # append to arrays
    tpl_names=("${tpl_names[@]}" "${!i}")
    tpl_scripts=("${tpl_scripts[@]}" "${!j}")
done

#----------------------------------
# step : source helper functions
source help_fncs.sh

# check that tpl names are admissible
check_tpl_names

echo "target tpls to build: ${tpl_names[@]}"
echo "target scripts: ${tpl_scripts[@]}"


#----------------------------------
# step : start building tpls

# do build
echo ""
echo "--------------------------------------------"
echo "**building tpls**"
echo ""

build_gtest() {
    local DOBUILD=OFF
    local scriptName=$1
    local myscript=${GTESTCONFIGDIR}/${scriptName}
    echo "script = ${myscript}.sh"
    [[ -d gtest ]] && check_and_clean gtest || DOBUILD=ON
    [[ $DOBUILD = "ON" ]] && bash ${myscript}.sh $ARCH $MODElib
}

build_eigen() {
    local DOBUILD=OFF
    local scriptName=$1
    local myscript=${EIGENCONFIGDIR}/${scriptName}
    echo "script = ${myscript}.sh"
    [[ -d gtest ]] && check_and_clean gtest || DOBUILD=ON
    [[ $DOBUILD = "ON" ]] && bash ${myscript}.sh $ARCH
}

build_trilinos() {
    local DOBUILD=OFF
    local scriptName=$1
    local myscript=${TRILINOSCONFIGDIR}/${scriptName}
    echo "script = ${myscript}.sh"
    [[ -d trilinos ]] && check_and_clean trilinos || DOBUILD=ON
    [[ $DOBUILD = "ON" ]] && bash ${myscript}.sh $MODEbuild $MODElib 4
}

# test is workdir exists if not create it
[[ ! -d $WORKDIR ]] && (echo "creating $WORKDIR" && mkdir $WORKDIR)

# enter working dir: make sure this happens because
# all scripts for each tpl MUST be run from within target dir
cd $WORKDIR

# now loop through TPLS and build
for ((i=0;i<${#tpl_names[@]};++i)); do
    name=${tpl_names[i]}
    script=${tpl_scripts[i]}
    echo "processing tpl = ${name}"

    [[ ${name} = "gtest" ]] && build_gtest ${script}
    [[ ${name} = "trilinos" ]] && build_trilinos ${script}
    [[ ${name} = "eigen" ]] && build_eigen ${script}
done

# return where we started from
cd $BASEDIR
