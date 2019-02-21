#!/bin/bash

MPIPATH=/Users/pblonig/Software/openmpi/3.1.2
export CC=${MPIPATH}/bin/mpicc
export CXX=${MPIPATH}/bin/mpic++
export MPIRUNe=${MPIPATH}/bin/mpirun

alias wget='curl -0'
