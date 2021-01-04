#!/bin/bash

# path to dir where eigen is installed
MCSSPATH=

function print_global_vars(){
    print_shared_global_vars

    echo "CMAKELINEGEN	      = $CMAKELINEGEN"
    echo "PRESSIOSRC	      = $PRESSIOSRC"
    echo "EIGENPATH	      = $EIGENPATH"
    echo "GTESTPATH	      = $GTESTPATH"
    echo "TRILINOSPATH	      = $TRILINOSPATH"
    echo "KOKKOSPATH	      = $KOKKOSPATH"
    echo "PYBIND11PATH	      = $PYBIND11PATH"
    echo "#cpu for make         = ${njmake}"
}
