#!/bin/bash

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

kokkos_omp(){
    CMAKELINE+="-D Trilinos_ENABLE_OpenMP:BOOL=ON "
    CMAKELINE+="-D KOKKOS_ENABLE_SERIAL:BOOL=OFF "
    CMAKELINE+="-D KOKKOS_ENABLE_THREADS:BOOL=OFF "
    CMAKELINE+="-D KOKKOS_ENABLE_OPENMP:BOOL=ON "
}

kokkos_serial(){
    CMAKELINE+="-D KOKKOS_ENABLE_SERIAL:BOOL=ON "
    CMAKELINE+="-D KOKKOS_ENABLE_THREADS:BOOL=OFF "
    CMAKELINE+="-D KOKKOS_ENABLE_OPENMP:BOOL=OFF "
}

packages_for_pressio(){
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

all_packages_on(){
    CMAKELINE+="-D Trilinos_ENABLE_ALL_PACKAGES:BOOL=ON "
}
