#!/usr/bin/env bash

# exit when there is error code
set -e

# print version of bash
echo "Bash version ${BASH_VERSION}"

# source colors for printing
source ./shared/colors.sh

############################################
# load helpers
############################################
# source the shared global vars
source ./shared/shared_global_vars.sh
# source my global vars
source ./website_build/global_vars.sh
# source tpls
source ./tpls/tpls_versions_details.sh
# source helper functions
source ./shared/helper_fncs.sh

############################################
# parse agrs
############################################
# parse cline arguments
source ./website_build/cmd_line_options.sh

# check that workdir is set
if [ -z $WORKDIR ]; then
    echo "${fgred}--target-repo is empty, must be set. Terminating. ${fgrst}"
    exit 12
fi

# check that mcss path is set
if [ -z $MCSSPATH ]; then
    echo "${fgred}--mcss-path is empty, must be set. Terminating. ${fgrst}"
    exit 12
fi

# print the current setting
echo ""
echo "${fgyellow}+++ Setup is as follows: +++ ${fgrst}"
echo "Target repo = ${WORKDIR}"
echo "mcss path   = ${MCSSPATH}"
echo ""

# set env if not already set
call_env_script

# check if you have a valid cmake
have_admissible_cmake
echo "${fggreen}Valid cmake found: ok! ${fgrst}"


# to build the website, we need:
# - m.css (passed via cmd line)
# - python, pip, doxygen, ninja2, pygments

have_admissible_python
echo "${fggreen}Valid python found: ok! ${fgrst}"
have_admissible_pip
echo "${fggreen}Valid pip found: ok! ${fgrst}"
have_admissible_doxygen
echo "${fggreen}Valid doxygen found: ok! ${fgrst}"

# before building all docs, need to process all
# demos and tutorial md files inside the repo
# such that we replace placeholders for the
# code snippets supposed to be show on the web.
# This is the main reason we are automatic the build of the docs.

# source functions for processing code snippets
source ./website_build/code_snippet_replace.sh

# process demo subdir
targets=(demos tutorials)
for k in "${targets[@]}"
do
    CURRPATH="${WORKDIR}/docs/pages/$k"
    if [ -d $CURRPATH ]; then
	echo "Processing all files in subdirectory ${CURRPATH}"
	files=(`ls ${CURRPATH}`)
	for i in "${files[@]}"
	do
	    echo $i
	    replace_code_snippets_in_file "${CURRPATH}/$i"
	done
    fi
done

### build website ###
CONFPATH="${WORKDIR}/docs/conf.py"
cd "${MCSSPATH}/documentation"
./doxygen.py ${CONFPATH}

# after website is complete, checkout the source files inside
# the demos becaue we don't want to leave them with the code
# snippets embedded inside, we want to leave the md files with
# just the "commands" for doing the code extraction
cd ${WORKDIR}

for k in "${targets[@]}"
do
    CURRPATH="${WORKDIR}/docs/pages/$k"
    if [ -d ${CURRPATH} ]; then
	git checkout ${CURRPATH}/*
    fi
    echo ${CURRPATH}
done

# return where we started
cd ${ORIGDIR}
