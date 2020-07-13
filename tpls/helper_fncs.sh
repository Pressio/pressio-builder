#!/usr/bin/env bash

function print_target_tpl_names(){
    echo "tpls		      = ${tpl_names[@]}"
}

function print_target_tpl_cmake_fncs(){
    # check how many tpls names we have
    local howMany=${#tpl_names[@]}
    # only print as many as TPL names
    echo "cmake_gen_fncs        = ${tpl_cmake_fncs[@]:0:${howMany}}"
}

function print_global_vars(){
    print_shared_global_vars
    print_target_tpl_names
    print_target_tpl_cmake_fncs
}

function check_minimum_vars_are_set(){
    # for TPLs, only need to check that the
    # shared vars are set
    check_minimum_shared_vars_set
    echo "${fggreen}Minimum vars all found: ok! ${fgrst}"
}

function check_if_both_trilinos_kokkos_are_selected()
{
    local trilinosFlag=false
    local kokkosFlag=false
    local kokkosKernelsFlag=false
    for ((i=0;i<${#tpl_names[@]};++i)); do
	name=${tpl_names[i]}
	if [ ${name} == trilinos ]; then
	    trilinosFlag=true
	fi
	if [ ${name} == kokkos ]; then
	    kokkosFlag=true
	fi
	if [ ${name} == kokkos-kernels ]; then
	    kokkosKernelsFlag=true
	fi
    done

    if [[ ${trilinosFlag} == true && ${kokkosFlag} == true ]] || \
	   [[ ${trilinosFlag} == true && ${kokkosKernelsFlag} == true ]] ||\
	   [[ ${trilinosFlag} == true && ${kokkosFlag} == true && ${kokkosKernelsFlag} == true ]];
    then
	echo "You selected to build both Trilinos and (Kokkos/kokkos-kernels), this is not allowed."
	echo "Trilinos already contains Kokkos and kokkos-kernels so I only build Trilinos."
	echo "If you really want to build them individually, then you have to build them separately but "
	echo "you are then responsible to use them correctly for pressio."

	local new_tpl_names=()
	local new_tpl_cmake_fncs=()
	for ((i=0;i<${#tpl_names[@]};++i)); do
	    name=${tpl_names[i]}
	    fnc=${tpl_cmake_fncs[i]}

	    if [[ $name == kokkos ]]; then
		unset 'tpl_names[i]'
		unset 'tpl_cmake_fncs[i]'
	    fi
	    if [[ $name == kokkos-kernels ]]; then
		unset 'tpl_names[i]'
		unset 'tpl_cmake_fncs[i]'
	    fi
	done
    fi
}


function check_tpls_order_is_admissible()
{
    echo "Checking order of the tpls"
    # currently, the only thing that matters is that Kokkos is built before kernels (if they are built)
    kokkosIndex=0
    kokkosKernelsIndex=0
    for ((i=0;i<${#tpl_names[@]};++i)); do
	name=${tpl_names[i]}
	if [ ${name} == kokkos ]; then
	    kokkosIndex="${i}"
	fi
	if [ ${name} == kokkos-kernels ]; then
	    kokkosKernelsIndex="${i}"
	fi
    done

    if [ ${kokkosIndex} -gt ${kokkosKernelsIndex} ];
    then
	echo "You passed kokkos and kokkos-kernels in the wrong order because"
	echo "kokkos must be built before kernels, so I am rearranging the order of the tpls to fix this."
	kokkosFncName=${tpl_cmake_fncs[${kokkosIndex}]}
	kokkosKerFncName=${tpl_cmake_fncs[${kokkosKernelsIndex}]}
	tpl_names[${kokkosIndex}]=kokkos-kernels
	tpl_names[${kokkosKernelsIndex}]=kokkos
	tpl_cmake_fncs[${kokkosIndex}]=${kokkosKerFncName}
	tpl_cmake_fncs[${kokkosKernelsIndex}]=${kokkosFncName}
    fi
}
