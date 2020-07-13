#!/usr/bin/env bash

function custom_cmake_gen()
{
	# these function can be found in ./pressio/cmake_building_blocks.sh
	# and are executed by the builder to generate the cmake line to configure
	# you can either use the functions in ./pressio/cmake_building_blocks.sh, 
	# or stich directly the env var CMAKELINE with regular cmake commands
    pressio_build_type
    pressio_cmake_verbose
    pressio_serial_c_cxx_compilers
    pressio_enable_eigen
    pressio_enable_gtest
    pressio_enable_debug_print
    pressio_tests_on
}
