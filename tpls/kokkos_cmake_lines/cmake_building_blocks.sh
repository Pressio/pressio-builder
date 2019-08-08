#!/bin/bash

# Note that it says trilinos below because these are used
# for building kokkos from Trilinos

always_needed(){
    local is_shared=ON
    local link_search_static=OFF
    if [[ ${MODElib} == static ]]; then
	is_shared=OFF
	link_search_static=ON
    fi
    echo "is_shared = $is_shared"
    echo "link_search_static = $link_search_static"

    CMAKELINE+="-D CMAKE_BUILD_TYPE:STRING=${MODEbuild} "
    CMAKELINE+="-D BUILD_SHARED_LIBS:BOOL=${is_shared} "
    CMAKELINE+="-D TPL_FIND_SHARED_LIBS=${is_shared} "
    CMAKELINE+="-D Trilinos_LINK_SEARCH_START_STATIC=$link_search_static "
    CMAKELINE+="-D Trilinos_ENABLE_EXPORT_MAKEFILES:BOOL=OFF "
    CMAKELINE+="-D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE "
}

mpi_compilers(){
    CMAKELINE+="-D TPL_ENABLE_MPI:BOOL=ON "
    CMAKELINE+="-D MPI_C_COMPILER:FILEPATH=${CC} "
    CMAKELINE+="-D MPI_CXX_COMPILER:FILEPATH=${CXX} "
    CMAKELINE+="-D MPI_EXEC:FILEPATH=${MPIRUNe} "
    CMAKELINE+="-D MPI_USE_COMPILER_WRAPPERS:BOOL=ON "
}

mpi_fortran_on(){
    CMAKELINE+="-D Trilinos_ENABLE_Fortran:BOOL=ON "
    CMAKELINE+="-D MPI_Fortran_COMPILER:FILEPATH=${FCC} "
}

mpi_fortran_off(){
    CMAKELINE+="-D Trilinos_ENABLE_Fortran:BOOL=OFF "
}

tests_off(){
    CMAKELINE+="-D Trilinos_ENABLE_TESTS:BOOL=OFF "
}

examples_off(){
    CMAKELINE+="-D Trilinos_ENABLE_EXAMPLES:BOOL=OFF "
}

kokkos_serial(){
    CMAKELINE+="-D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF "
    CMAKELINE+="-D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF "

    CMAKELINE+="-D Trilinos_ENABLE_Kokkos=ON "
    CMAKELINE+="-D Trilinos_ENABLE_KokkosKernels=ON "
    CMAKELINE+="-D TPL_ENABLE_BLAS=ON "
    CMAKELINE+="-D TPL_ENABLE_LAPACK=ON "

    CMAKELINE+="-D Kokkos_ENABLE_Serial=ON "
    CMAKELINE+="-D Kokkos_ENABLE_OpenMP=OFF "
    CMAKELINE+="-D Kokkos_ENABLE_Pthread=OFF "
    CMAKELINE+="-D Kokkos_ENABLE_Cuda=OFF "
    CMAKELINE+="-D Kokkos_ENABLE_Cuda_UVM=OFF "
}
