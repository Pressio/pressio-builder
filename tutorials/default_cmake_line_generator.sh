#!/bin/bash

#------------------------------------------
# default generator function for tutorials
#------------------------------------------
function default() {
    pressio_tut_always_needed
    pressio_tut_cmake_verbose

    pressio_tut_serial_c_cxx_compilers

    pressio_tut_eigen
    pressio_tut_pressio
}
