#!/usr/bin/env bash

# the pressio packages dependency structure is:
# mpl		: always needed
# utils		: always needed
# containers	: depends on mpl, utils
# qr		: depends on mpl, utils, containers
# solvers	: depends on mpl, utils, containers, qr
# svd		: depends on mpl, utils, containers, qr, solvers
# ode		: depends on mpl, utils, containers, solvers
# rom		: depends on mpl, utils, containers, qr, solvers, svd, ode
# apps		: depends on mpl, utils, containers, qr, solvers, svd, ode, rom

# mpl, utils always on
buildMPL=ON
buildUTILS=ON
# the others are turned on depending on arguments
buildCONTAINERS=OFF
buildQR=OFF
buildSOLVERS=OFF
buildSVD=OFF
buildODE=OFF
buildROM=OFF
buildAPPS=OFF

# turn flags on/off according to choices
if [[ " ${pkg_names[@]} " =~ "containers" ]]; then
    echo "${fggreen} Turning on: mpl, utils, containers"
    buildCONTAINERS=ON
fi
if [[ " ${pkg_names[@]} " =~ "qr" ]]; then
    echo "${fggreen} You chose qr => turning on also mpl, utils, containers"
    buildCONTAINERS=ON
    buildQR=ON
fi

if [[ " ${pkg_names[@]} " =~ "solvers" ]]; then
    echo "${fggreen} You chose solvers => turning on also mpl, utils, containers, qr"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
fi

if [[ " ${pkg_names[@]} " =~ "svd" ]]; then
    echo "${fggreen} You chose svd => turning on also mpl, utils, containers, qr, solvers, svd"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
fi

if [[ " ${pkg_names[@]} " =~ "ode" ]]; then
    echo "${fggreen} You chose ode => turning on also mpl, utils, containers, solvers"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildODE=ON
fi

if [[ " ${pkg_names[@]} " =~ "rom" ]]; then
    echo "${fggreen} You chose rom => turning on also mpl, utils, containers, qr, solvers, svd, ode"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
    buildODE=ON
    buildROM=ON
fi

if [[ " ${pkg_names[@]} " =~ "apps" ]]; then
    echo "${fggreen} You chose apps => turning on also mpl, utils, containers, qr, solvers, svd, ode, rom"
    buildCONTAINERS=ON
    buildQR=ON
    buildSOLVERS=ON
    buildSVD=ON
    buildODE=ON
    buildROM=ON
    buildAPPS=ON
fi
