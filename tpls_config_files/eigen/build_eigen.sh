#!/bin/bash

#----------------------------------
# step : test cline arguments

n_args=$#
if test $n_args -lt 1; then
    str+="[linux/mac] "

    echo "usage:"
    echo "$0 $str"
    exit 1;
fi


build(){
    local PWD=`pwd`
    local PARENTDIR=$PWD

    local is_mac=OFF
    [[ $1 == mac ]] && is_mac=ON
    echo "is_mac = $is_mac"
    #-----------------------------------

    # create dir
    [[ ! -d eigen ]] && mkdir eigen
    cd eigen

    # clone repo
    if [ ! -d eigen-eigen-b3f3d4950030 ]; then
	wget http://bitbucket.org/eigen/eigen/get/3.3.5.tar.bz2
	tar zxf 3.3.5.tar.bz2
    fi

    echo `pwd`
    mkdir -p install/Eigen
    ls
    cp -rf eigen-eigen-b3f3d4950030/Eigen/* install/Eigen

    cd ${PARENTDIR}
}

build $1
