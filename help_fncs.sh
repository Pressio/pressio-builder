#!/bin/bash

check_tpl_names() {
    echo "checking tpl names are admissible"
    # todo: put here code to check that tpl names are admissible
    # by comparing each name against a list of supported tpls
    echo "done checking tpl names!"
}


check_and_clean(){
    local parentdir=$1
    if [ $WIPEEXISTING -eq 1 ]; then
	echo "wiping $parentdir/build"
    echo "wiping $parentdir/install"
	rm -rf $parentdir/build $parentdir/install
	DOBUILD=ON
    else
	echo "$parentdir exists: skipping"
    fi
}
