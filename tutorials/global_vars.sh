#!/bin/bash

# path to dir where eigen is installed
EIGENPATH=

# path to dir where pressio is installed
PRESSIOPATH=

# pressio-tutorials git repo src
PRESSIOTUTORIALSSRC=

# name of the cmake configuring line
CMAKELINEGEN=default

# n to use for parallelizing make
njmake=4

function print_global_vars(){
    print_shared_global_vars
    echo "EIGENPATH	      = $EIGENPATH"
    echo "PRESSIOPATH	      = $PRESSIOPATH"
    echo "PRESSIOTUTORIALSSRC = $PRESSIOTUTORIALSSRC"
    echo "# cpu for make      = ${njmake}"
}

function check_minimum_vars_set(){
    # check for shared vars
    check_minimum_shared_vars_set
    echo "${fggreen}Minimum shared vars found: ok! ${fgrst}"

    if [ -z $EIGENPATH ]; then
	echo "${fgred}--eigen-path is empty, you must set it."
	echo "${fgred}Eigen is a required dependency. Terminating.${fgrst}"
	exit 0
    fi
    if [ -z $PRESSIOPATH ]; then
	echo "${fgred}--pressio-path is empty, you must set it."
	echo "${fgred}Pressio is a required dependency. Terminating.${fgrst}"
	exit 0
    fi
}
