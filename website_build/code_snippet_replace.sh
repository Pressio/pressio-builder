#!/bin/bash

function replace_single_code_snippet()
{
    snippetstartline=$1
    originalfile=$2
    originalfilepath=$(dirname "${originalfile}")
    echo $originalfilepath

    codeFileLN=$(($snippetstartline+1))
    boundsLN=$(($snippetstartline+2))

    # the file where the code is to be extracted from
    codeFile="${originalfilepath}/$(sed "${codeFileLN}!d" $originalfile)"

    # the lines bounds of the code in the source file
    bounds=$(sed "${boundsLN}!d" $originalfile)
    boundsArr=(${bounds//:/ })
    codeStartsAt=${boundsArr[0]}
    codeEndsAt=${boundsArr[1]}
    echo "codefile = $codeFile"
    echo "code bounds = ${codeStartsAt}:${codeEndsAt}"

    # get the file extension
    ext="${originalfile##*.}"

    # check if tmp file is present
    tmpfile=tmp.${ext}
    [[ -f tmpfile ]] && rm ${tmpfile}

    # move updated content to tmpfile (there is a better way)
    head -n $(($snippetstartline-1)) ${originalfile} > ${tmpfile}
    sed "${codeStartsAt},${codeEndsAt}!d" ${codeFile} >> ${tmpfile}
    jumpl=$(($snippetstartline+3))
    awk "NR>=${jumpl}" ${originalfile} >> ${tmpfile}

    # now replace old file with this
    cat ${tmpfile} > ${originalfile}
    rm -f ${tmpfile}
}

function replace_code_snippets_in_file()
{
    echo "Processing code snippets in file: $1"

    # find how many instances I have to replace
    items=($(grep -n "@codesnippet" $1))
    N=${#items[@]}
    echo $N
    if [ "$N" -gt "0" ]; then
	for i in $(seq 0 1 $(($N-1)))
	do
	    # every time I loop i have to regrep since files changes
	    items2=($(grep -n "@codesnippet" $1))
	    entry=${items2[0]}
	    echo $entry
	    startline=(${entry//:/ })
	    replace_single_code_snippet $startline $1
	done
    fi
}
