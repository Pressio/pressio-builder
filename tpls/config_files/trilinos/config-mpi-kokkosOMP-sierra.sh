#!/bin/bash

EXTRA_ARGS=$@
TRILINOS_SRC_DIR=/projects/rompp/tpls/trilinos/Trilinos
PFX=/projects/rompp/tpls/trilinos/install-sierra
MPIPATH=/projects/sierra/linux_rh6/SDK/mpi/openmpi/1.10.2-gcc-7.2.0-RHEL6

cmake \
    -D CMAKE_BUILD_TYPE:STRING=DEBUG \
    -D CMAKE_INSTALL_PREFIX:PATH=${PFX} \
    \
    -D BUILD_SHARED_LIBS:BOOL=OFF \
    -D TPL_FIND_SHARED_LIBS=OFF \
    -D Trilinos_LINK_SEARCH_START_STATIC=ON \
    \
    -D TPL_ENABLE_MPI:BOOL=ON \
    -D MPI_BASE_DIR:PATH=${MPIPATH} \
    -D MPI_EXEC:FILEPATH=${MPIPATH}/bin/mpirun \
    -D Trilinos_ENABLE_EXPORT_MAKEFILES:BOOL=OFF \
    -D TPL_ENABLE_BoostLib:BOOL=OFF \
    -D Trilinos_ENABLE_Fortran:BOOL=OFF \
    -D Trilinos_ENABLE_TESTS:BOOL=OFF \
    -D Trilinos_ENABLE_EXAMPLES:BOOL=OFF \
    -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=ON \
    -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
    \
    -D Trilinos_ENABLE_OpenMP:BOOL=ON \
    -D KOKKOS_ENABLE_SERIAL:BOOL=ON \
    -D KOKKOS_ENABLE_THREADS:BOOL=OFF \
    -D KOKKOS_ENABLE_OPENMP:BOOL=ON \
    \
    -D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE \
    ${TRILINOS_SRC_DIR} \
    $EXTRA_ARGS

    # -D Trilinos_ENABLE_Teuchos:BOOL=ON \
    # -D Trilinos_ENABLE_Epetra:BOOL=ON \
    # -D Trilinos_ENABLE_Tpetra:BOOL=ON \
    # -D Trilinos_ENABLE_EpetraExt:BOOL=ON \
    # -D Trilinos_ENABLE_AztecOO:BOOL=ON \
    # -D Trilinos_ENABLE_Anasazi:BOOL=ON \
    # -D Trilinos_ENABLE_Ifpack:BOOL=ON \
    # -D Trilinos_ENABLE_Ifpack2:BOOL=ON \

