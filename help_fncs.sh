#!/bin/bash

check_and_clean(){
    echo "chec clean"

    local parentdir=$1
    if [ $WIPEEXISTING -eq 1 ]; then
	echo "within ${PWD}$"
	echo "wiping $parentdir/build"
	echo "wiping $parentdir/install"
	rm -rf $parentdir/build $parentdir/install
	DOBUILD=ON
    else
	echo "$parentdir exists: skipping"
	exit 0
    fi
}


call_env_script(){
    echo "call env"

    if [[ ! -z ${SETENVscript} ]]; then
	echo "loading environment from ${SETENVscript}"
	source ${SETENVscript}
	echo "PATH = $PATH"
    else
	echo "--with-env-script NOT set, so we assume env is set already"
    fi
}
