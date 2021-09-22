#!/usr/bin/env bash

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
    exit 1
fi

# check that mcss path is set
if [ -z $MCSSPATH ]; then
    echo "${fgred}--mcss-path is empty, must be set. Terminating. ${fgrst}"
    exit 1
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

# find which repo we are building the website for:
# it could be pressio, pressio-tutorials, or pressio4py
repoName=$(basename ${WORKDIR})

# depending on which repo we are working on,
# we need to provide list of target dirs where
# there are possible md files with "code snippets"
# to replace
if [ ${repoName} == "pressio-tutorials" ];
then
    # # store all subdires inside pressio-tutorials/docs/pages
    # cd ${WORKDIR}/docs/pages
    # cnt=0
    # for d in *; do
    #   [ -d "$d" ] || continue
    #   targets[$cnt]="$d"
    #   ((++cnt))
    # done
    # cd -
    targets=(utils solvers_nonlinear ode rom) 
elif [ ${repoName} == "pressio4py" ];
then
    targets=(demos tutorials)
elif [ ${repoName} == "pressio" ]; then
    targets=()
fi

# process all code snippets replacements
for k in "${targets[@]}"
do
    echo $k
    CURRPATH="${WORKDIR}/docs/pages/$k"
    if [ -d $CURRPATH ]; then
	echo "Processing all files in subdirectory ${CURRPATH}"
	files=(`ls ${CURRPATH}`)
	for i in "${files[@]}"
	do
	    # make a copy of the file BEFORE we replace code snippts
	    # so that we can use that backup to revert after we build website
	    cp ${CURRPATH}/$i ${CURRPATH}/$i.backup

	    replace_code_snippets_in_file "${CURRPATH}/$i" || true
	done
    fi
done

### build website ###
CONFPATH="${WORKDIR}/docs/conf.py"
cd "${MCSSPATH}/documentation"

echo ""
echo "${fgyellow}+++ Building website as: +++ ${fgrst}"
echo ".${MCSSPATH}/documentation/doxygen.py ${CONFPATH}"
echo ""
./doxygen.py ${CONFPATH} || true

# after website build is complete, we need to revert the md
# files becaue we don't want to leave them with the code
# snippets embedded inside, we want to leave the md files with
# just the "commands" for doing the code extraction.
# Note that we have to do this no matter what, even if the
# build of the website failed otherwise the source files
# will be left in a wrong state.
# To do this, use the backup files create above while processing.
cd ${WORKDIR}
for k in "${targets[@]}"
do
    CURRPATH="${WORKDIR}/docs/pages/$k"
    if [ -d ${CURRPATH} ]; then
	files=(`ls ${CURRPATH}/*.md`)
	for i in "${files[@]}"
	do
	    echo $i
	    mv $i.backup $i
	done
    fi
    echo ${CURRPATH}
done

# return where we started
cd ${ORIGDIR}
