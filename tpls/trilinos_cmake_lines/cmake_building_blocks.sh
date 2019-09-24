#!/bin/bash

function trilinos_build_type(){
    CMAKELINE+="-D CMAKE_BUILD_TYPE:STRING=${MODEbuild} "
}

function trilinos_link_type(){
    local is_shared=ON
    local link_search_static=OFF
    if [[ ${LINKTYPE} == static ]]; then
	is_shared=OFF
	link_search_static=ON
    fi
    echo "is_shared = $is_shared"
    echo "link_search_static = $link_search_static"

    CMAKELINE+="-D BUILD_SHARED_LIBS:BOOL=${is_shared} "
    CMAKELINE+="-D TPL_FIND_SHARED_LIBS=${is_shared} "
    CMAKELINE+="-D Trilinos_LINK_SEARCH_START_STATIC=$link_search_static "
}

function trilinos_verbose_makefile_on(){
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
}

function trilinos_mpi_c_cxx_compilers(){
    CMAKELINE+="-D TPL_ENABLE_MPI:BOOL=ON "
    CMAKELINE+="-D MPI_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D MPI_CXX_COMPILER:FILEPATH=${CXX} "
    CMAKELINE+="-D MPI_EXEC:FILEPATH=${MPIRUNe} "
    CMAKELINE+="-D MPI_USE_COMPILER_WRAPPERS:BOOL=ON "
}

function trilinos_mpi_fortran_on(){
    CMAKELINE+="-D Trilinos_ENABLE_Fortran:BOOL=ON "
    CMAKELINE+="-D MPI_Fortran_COMPILER:FILEPATH=${FC} "
}

function trilinos_fortran_off(){
    CMAKELINE+="-D Trilinos_ENABLE_Fortran:BOOL=OFF "
}

function trilinos_tests_off(){
    CMAKELINE+="-D Trilinos_ENABLE_TESTS:BOOL=OFF "
}

function trilinos_examples_off(){
    CMAKELINE+="-D Trilinos_ENABLE_EXAMPLES:BOOL=OFF "
}

function trilinos_kokkos_omp(){
    CMAKELINE+="-D Trilinos_ENABLE_OpenMP:BOOL=ON "
    CMAKELINE+="-D KOKKOS_ENABLE_SERIAL:BOOL=OFF "
    CMAKELINE+="-D KOKKOS_ENABLE_THREADS:BOOL=OFF "
    CMAKELINE+="-D KOKKOS_ENABLE_OPENMP:BOOL=ON "
}

function trilinos_kokkos_serial(){
    CMAKELINE+="-D KOKKOS_ENABLE_SERIAL:BOOL=ON "
    CMAKELINE+="-D KOKKOS_ENABLE_THREADS:BOOL=OFF "
    CMAKELINE+="-D KOKKOS_ENABLE_OPENMP:BOOL=OFF "
}

function trilinos_packages_for_pressio(){
    CMAKELINE+="-D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF "
    CMAKELINE+="-D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF "
    CMAKELINE+="-D Trilinos_ENABLE_Teuchos:BOOL=ON "
    CMAKELINE+="-D Trilinos_ENABLE_Epetra:BOOL=ON "
    CMAKELINE+="-D Trilinos_ENABLE_Tpetra:BOOL=ON "
    CMAKELINE+="-D Tpetra_ENABLE_TSQR:BOOL=ON "
    CMAKELINE+="-D Trilinos_ENABLE_EpetraExt:BOOL=ON "
    CMAKELINE+="-D Trilinos_ENABLE_AztecOO:BOOL=ON "
    #CMAKELINE+="-D Trilinos_ENABLE_Anasazi:BOOL=ON "
    #CMAKELINE+="-D Anasazi_ENABLE_TSQR:BOOL=ON "
    CMAKELINE+="-D Trilinos_ENABLE_Ifpack:BOOL=ON "
    CMAKELINE+="-D Trilinos_ENABLE_Ifpack2:BOOL=ON "
}

function trilinos_all_packages_on(){
    CMAKELINE+="-D Trilinos_ENABLE_ALL_PACKAGES:BOOL=ON "
}

function trilinos_blas_on(){
    CMAKELINE+="-D TPL_ENABLE_BLAS=ON "
}

function trilinos_lapack_on(){
    CMAKELINE+="-D TPL_ENABLE_LAPACK=ON "
}

function trilinos_openblaslapack(){
    CMAKELINE+="-D TPL_ENABLE_BLAS=ON "
    # note that BLAS_ROOT needs to be set by environemnt
    if [ -z ${BLAS_ROOT} ]; then
	echo "You are tryin to enable openblas:"
	echo "BLAS_ROOT needs to be set in the environment"
	exit 0
    fi
    CMAKELINE+="-D BLAS_LIBRARY_DIRS:PATH='${BLAS_ROOT}/lib' "
    CMAKELINE+="-D BLAS_LIBRARY_NAMES:STRING='openblas' "

    CMAKELINE+="-D TPL_ENABLE_LAPACK=ON "
    # note that LAPACK_ROOT needs to be set by environemnt
    if [ -z ${LAPACK_ROOT} ]; then
	echo "You are tryin to enable openblas:"
	echo "LAPACK_ROOT needs to be set in the environment"
	exit 0
    fi
    CMAKELINE+="-D LAPACK_LIBRARY_DIRS:PATH='${LAPACK_ROOT}/lib' "
    CMAKELINE+="-D LAPACK_LIBRARY_NAMES:STRING='openblas' "
}
