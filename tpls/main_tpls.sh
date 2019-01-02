#!/bin/bash

echo "Bash version ${BASH_VERSION}"

# PWD will be updated if we change directory
PWD=`pwd`

# load all global variables
source global_vars.sh

# step : parse cline arguments
source cmd_line_options.sh

# check that all basic variables are set, otherwise leave
check_minimum_vars_set

echo ""
echo "--------------------------------------------"
echo " current setting is: "
echo ""
print_global_vars

# source helper functions
source ../help_fncs.sh

# set env if not already set
call_env_script

# check admissible tpl names
check_tpl_names() {
    echo "checking tpl names are admissible"
    # todo: put here code to check that tpl names are admissible
    # by comparing each name against a list of supported tpls
    echo "done checking tpl names!"
}

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
    [[ -d eigen ]] && check_and_clean eigen || DOBUILD=ON
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
cd ${THISDIR}
