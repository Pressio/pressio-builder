#!/usr/bin/env bash

function print_message_dryrun_no(){
    echo ""
    echo "${fgyellow}!!! Since dryrun=no, I am just displaying commands.${fgrst}"
    echo "${fgyellow}!!! If you want to actually conf/build/install, set dryrun=no.${fgrst}"
    echo ""
}

function check_and_clean(){
    local targetdir=$1
    if [ $WIPEEXISTING == yes ]; then
	if [ ${DRYRUN} == no ]; then
	    echo "wiping ${PWD}/$targetdir/build"
	    echo "wiping ${PWD}/$targetdir/install"
	    rm -rf ${targetdir}/build ${targetdir}/install
	else
	    echo "with dryrun=no, I would wipe ${PWD}/$targetdir/build"
	    echo "with dryrun=no, I would wipe ${PWD}/$targetdir/install"
	fi
	DOBUILD=ON
    else
	echo "${PWD}/$targetdir already exists: skipping"
	echo "If you want to re-build $targetdir, set wipe-existing=yes and dryrun=no"
    fi
}

function call_env_script(){
    if [[ ! -z ${SETENVscript} ]]; then
	echo ""
	echo "${fgyellow}+++ Loading environment from ${SETENVscript} +++${fgrst}"
	source ${SETENVscript}
	echo "Your PATH = $PATH"
    else
	echo "${fgyellow}+++ --with-env-script is empty. I assume env is set +++${fgrst}"
    fi
}

function version {
    echo "$@" | awk -F. '{ printf("%d%02d%02d\n", $1,$2,$3); }';
}

################################
#	CMAKE
################################
function detect_cmake(){
    # check if cmake is found in PATH
    if [ -x "$(command -v cmake)" ]; then
	CMAKEVERSIONDETECTED="$(cmake --version | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')"
    fi
}

function have_admissible_cmake(){
    # detect cmake
    detect_cmake
    echo ""
    echo "${fgyellow}+++ Detecting which cmake you have +++${fgrst}"
    echo "CMAKEVERSIONDETECTED=$CMAKEVERSIONDETECTED"

    if [ -z $CMAKEVERSIONDETECTED ]; then
	# if cmakeversion is empty
	echo "${fgred}No Cmake found. Terminating. ${fgrst}"
	echo "${fgred}You need cmake >= ${CMAKEVERSIONMIN}. ${fgrst}"
	exit 15
    else
	# if cmakeversion is NOT empty but wrong version
    	if [ $(version $CMAKEVERSIONDETECTED) -lt $(version "$CMAKEVERSIONMIN") ]; then
	    echo "${fgred}You have cmake ${CMAKEVERSIONDETECTED} ${fgrst}"
	    echo "${fgred}while I need >=${CMAKEVERSIONMIN}. Terminate.${fgrst}"
    	    exit 15
    	else
	    return 0
    	fi
    fi
}

################################
#	PYTHON
################################
function detect_python(){
    if [ -x "$(command -v cmake)" ]; then
	PYTHONVERSIONDETECTED="$(python --version | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')"
    fi
}

function have_admissible_python(){
    detect_python
    echo ""
    echo "${fgyellow}+++ Detecting if you have python +++${fgrst}"
    echo "PYTHONVERSIONDETECTED=$PYTHONVERSIONDETECTED"

    if [ -z $PYTHONVERSIONDETECTED ]; then
	echo "${fgred}No Python found. Terminating. ${fgrst}"
	echo "${fgred}You need python >= ${PYTHONVERSIONMIN}. ${fgrst}"
	exit 15
    else
	# if pythonversion is NOT empty but wrong version
    	if [ $(version $PYTHONVERSIONDETECTED) -lt $(version "$PYTHONVERSIONMIN") ]; then
	    echo "${fgred}You have python ${PYTHONVERSIONDETECTED} ${fgrst}"
	    echo "${fgred}while I need >=${PYTHONVERSIONMIN}. Terminate.${fgrst}"
    	    exit 15
    	else
	    return 0
    	fi
    fi
}


################################
#	PIP
################################
function detect_pip(){
    if [ -x "$(command -v cmake)" ]; then
	PIPVERSIONDETECTED="$(pip --version | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')"
    fi
}

function have_admissible_pip(){
    detect_pip
    echo ""
    echo "${fgyellow}+++ Detecting if you have pip +++${fgrst}"
    echo "PIPVERSIONDETECTED=$PIPVERSIONDETECTED"

    if [ -z $PIPVERSIONDETECTED ]; then
	echo "${fgred}No Pip found. Terminating. ${fgrst}"
	echo "${fgred}You need pip. ${fgrst}"
	exit 15
    # else
    # 	# if pipversion is NOT empty but wrong version
    # 	if [ $(version $PIPVERSIONDETECTED) -lt $(version "$PIPVERSIONMIN") ]; then
    # 	    echo "${fgred}You have pip ${PIPVERSIONDETECTED} ${fgrst}"
    # 	    echo "${fgred}while I need >=${PIPVERSIONMIN}. Terminate.${fgrst}"
    # 	    exit 15
    # 	else
    # 	    return 0
    # 	fi
    fi
}

################################
#	DOXYGEN
################################
function detect_doxygen(){
    if [ -x "$(command -v cmake)" ]; then
	DOXYGENVERSIONDETECTED="$(doxygen --version | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/')"
    fi
}

function have_admissible_doxygen(){
    detect_doxygen
    echo ""
    echo "${fgyellow}+++ Detecting if you have doxygen +++${fgrst}"
    echo "DOXYGENVERSIONDETECTED=$DOXYGENVERSIONDETECTED"

    if [ -z $DOXYGENVERSIONDETECTED ]; then
	echo "${fgred}No Doxygen found. You need to install it! Terminating. ${fgrst}"
	echo "${fgred}You need doxygen >= ${DOXYGENVERSIONMIN}. ${fgrst}"
	exit 15
    else
	# if doxygenversion is NOT empty but wrong version
    	if [ $(version $DOXYGENVERSIONDETECTED) -lt $(version "$DOXYGENVERSIONMIN") ]; then
	    echo "${fgred}You have doxygen ${DOXYGENVERSIONDETECTED} ${fgrst}"
	    echo "${fgred}while I need >=${DOXYGENVERSIONMIN}. Terminate.${fgrst}"
    	    exit 15
    	else
	    return 0
    	fi
    fi
}


function print_shared_global_vars(){
    echo "ORIGDIR               = $ORIGDIR"
    echo "OS Running            = $ARCH"
    echo "WORKDIR               = $WORKDIR"
    echo "WIPEEXISTING          = ${WIPEEXISTING}"
    echo "DRYUN                 = ${DRYRUN}"

    if [ ! -z $MODEbuild ]; then
	echo "MODEbuild             = $MODEbuild"
    else
	echo "MODEbuild             = -"
    fi

    if [ ! -z $LINKTYPE ]; then
	echo "LINKTYPE              = $LINKTYPE"
    else
	echo "LINKTYPE              = -"
    fi

    if [ ! -z $SETENVscript ]; then
	echo "SETENVscript          = $SETENVscript"
    else
	echo "SETENVscript          = -"
    fi

    if [ ! -z $CMAKELINEGENFNCscript ]; then
	echo "CMAKELINEGENFNCscript = $CMAKELINEGENFNCscript"
    else
	echo "CMAKELINEGENFNCscript = -"
    fi

    if [ ! -z $DUMPTOFILEONLY ]; then
	echo "DUMPTOFILEONLY        = $DUMPTOFILEONLY"
    else
	echo "DUMPTOFILEONLY        = -"
    fi
}

function check_minimum_shared_vars_set(){
    if [ -z $WORKDIR ]; then
	echo "${fgred}--target-dir is empty, must be set. Terminating. ${fgrst}"
	exit 12
    fi
}
