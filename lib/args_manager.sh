# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:
#
#                                   _      _
#                   _o)   __ _  ___/ /__ _/ /_  __ _  (o_
#################   /\\  /  ' \/ _  / _ `/ _  \/  ' \ //\   ##################
#                   \_v /_/_/_/\_,_/\_, /_/ /_/_/_/_/ v_/
#                                  /___/
#
# Author:       Michel Massaro
# Version :     V1.0
# Date :        20/01/17
# Description : 
#
#
##############################################################################

# TODO PRIORITE : revoir les fonctions get_index + remove


# XXX dans l'ideal on installe ca dans un .projet_latex
# XXX Bash/ksh : array from 0 !!! Zsh and other array from 1
# XXX KSH = meme traitement que bash
# XXX Deux choses prioritaires.
# 1: la fonction recherche doit rechercher exactement les termes
# 2: il faut verifier que les champs entrés sont bons
# XXX Le declare -g ne fonctionne pas avec les anciennes version de bash
# XXX Il faut ajouter une fonction qui importe une fonction fonction de
# l'utilisateur et une autre qui en telecharge une


function _get_index(){
    index="$(echo ${opt_list[@]/$1//} | cut -d/ -f1 | wc -w | tr -d ' ')"
    last=${#opt_list[@]}
    if [ "$index" = "$last" ]; then
        echo "Error : Option $1 not found"
        # XXX valeur de retour pour l'erreur
        index=1000
    fi
}


function _get_index_silent(){
    index="$(echo ${opt_list[@]/$1//} | cut -d/ -f1 | wc -w | tr -d ' ')"
    last=${#opt_list[@]}
    if [ "$index" = "$last" ]; then
        index=1000
    fi
}


function _add_desc(){
    func_desc+=("$1")
}

function _remove_desc(){
    if [ -z ${func_desc+x} ]; then
        echo "Error : Cannot remove option"
    else
        # XXX il faudrait pouvoir supprimer les exemples sans tout supprimer
        unset func_desc
    fi
}

function set_desc(){
    if [ "$1" = "add" ]; then
        if [ -z ${func_desc+x} ]; then
            func_desc=()
        fi

        _add_desc "$2"
    elif [ "$1" = "remove" ]; then
        if [ -z ${func_desc+x} ]; then
            echo "There is no function to set"
        else
            _remove_desc $2
        fi
    else
        echo "ERROR : 1st argument must be 'add' or 'remove'"
    fi
}


function _add_opt(){
    opt_list+=($1)
    opt_desc+=("$2")
}

function _remove_opt(){
    if [ -z ${opt_list+x} ] || [ -z ${opt_desc+x} ]; then
        echo "Error : Cannot remove option"
    else
        _get_index $1
        # XXX verifier si on a trouve
        if [ -z $BASH_SOURCE]; then
            im1=$index
            ip1=$((index+2))
            end=${#opt_list[@]}
        else
            im1=$((index-1))
            ip1=$((index+1))
            end=${#opt_list[@]}
            end=$((end-1))
        fi

        opt_list=(${opt_list[1,$im1]} ${opt_list[$ip1,$end]})
        opt_desc=(${opt_desc[1,$im1]} ${opt_desc[$ip1,$end]})
    fi
}


function set_opt_list(){
    if [ "$1" = "add" ]; then
        if [ -z ${opt_list+x} ]; then
            opt_list=()
        fi
        if [ -z ${opt_desc+x} ]; then
            opt_desc=()
        fi

        _add_opt $2 "$3"
    elif [ "$1" = "remove" ]; then
        if [ -z ${opt_list+x} ] || [ -z ${opt_desc+x} ]; then
            echo "There is no option list to set"
        else
            _remove_opt $2
        fi
    else
        echo "ERROR : 1st argument must be 'add' or 'remove'"
    fi
}






function set_args(){
    array=()
    for args in $@;
    do
        array+=("$args")
    done

    export _SET_DEFAULT_="1"
    if [ -z $BASH_SOURCE ]; then
        source $PMNG/func/${array[1]}/param_${array[1]}.sh
    else
        source $PMNG/func/${array[0]}/param_${array[0]}.sh
    fi
    unset _SET_DEFAULT_

    if [ -z $BASH_SOURCE ]; then
        for ((i=1; i<=${#array[@]}; i++))
        do
            _get_index_silent ${array[$i]}
            if [[ $index != 1000 ]]; then
                opt=$(echo ${opt_list[$((index+1))]} | sed 's/-/m/')
                ptr_opt="$opt"
                declare -g "$ptr_opt"="${array[$((i+1))]}"
            fi
        done
    else
        for ((i=0; i<${#array[@]}; i++))
        do
            _get_index_silent ${array[$i]}
            if [[ $index != 1000 ]]; then
                opt=$(echo ${opt_list[$((index))]} | sed 's/-/m/')
                ptr_opt="$opt"
                declare -g "$ptr_opt"="${array[$((i+1))]}"
            fi
        done
    fi

    unset ptr_opt
    unset opt
    unset opt_desc
    unset opt_list
    unset func_desc
}







function test_set_params(){
    set_args $@
    echo $mtoto $mtutu $mtiti $mtata
}






for f in $(/bin/ls $PMNG/projects/enable);
do
    source $PMNG/projects/enable/$f/*.sh;
done




