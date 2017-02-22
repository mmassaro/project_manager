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



# XXX Bash/ksh : array from 0 !!! Zsh and other array from 1
# XXX KSH = meme traitement que bash

# XXX Deux choses prioritaires.
# OK 1: la fonction recherche doit rechercher exactement les termes
# 2: il faut verifier que les champs entrés sont bons


#_get_index(){
#    index="$(echo ${opt_list[@]/$1//} | cut -d/ -f1 | wc -w | tr -d ' ')"
#    last=${#opt_list[@]}
#    if [ "$index" = "$last" ]; then
#        echo "Error : Option $1 not found"
#        # XXX valeur de retour pour l'erreur
#        index=1000
#    fi
#}
#
#_get_index_silent(){
#    index="$(echo ${opt_list[@]/$1//} | cut -d/ -f1 | wc -w | tr -d ' ')"
#    last=${#opt_list[@]}
#    if [ "$index" = "$last" ]; then
#        index=1000
#    fi
#}


# Attention difference bash zsh. bash de 0 a n-1
_get_index() {
    local it=0
    if [ -z $BASH_SOURCE ]; then
        while [ "${opt_list[$it]}" != "$1"  ] && [ $it -le "${#opt_list[@]}" ]; do 
            ((it++)); 
        done
        if [ $it -le "${#opt_list[@]}"  ]; then
            index=$it
            return 0
        else
            echo "Error : Option $1 not found"
            index=1000
            return 1
        fi
    else
        while [ "${opt_list[$it]}" != "$1"  ] && [ $it -lt "${#opt_list[@]}" ]; do 
            ((it++)); 
        done
        if [ $it -lt "${#opt_list[@]}"  ]; then
            index=$it
            return 0
        else
            echo "Error : Option $1 not found"
            index=1000
            return 1
        fi
    fi
}

_get_index_silent() {
    local it=0
    if [ -z $BASH_SOURCE ]; then
        while [ "${opt_list[$it]}" != "$1"  ] && [ $it -le "${#opt_list[@]}" ]; do 
            ((it++)); 
        done
        if [ $it -le "${#opt_list[@]}"  ]; then
            index=$it
            return 0
        else
            index=1000
            return 1
        fi
    else
        while [ "${opt_list[$it]}" != "$1"  ] && [ $it -lt "${#opt_list[@]}" ]; do 
            ((it++)); 
        done
        if [ $it -lt "${#opt_list[@]}"  ]; then
            index=$it
            return 0
        else
            index=1000
            return 1
        fi
    fi
}




_add_desc(){
    func_desc+=("$1")
}

# dans le display, les options sont numeroté.
# je peux donc faire en sorte de supprimer l'exemple numéro i
_remove_desc(){
    if [ -z ${func_desc+x} ] || [[ $1 -ge ${#func_desc[@]} ]]; then
        echo "Error : Cannot remove option"
    else

        if [ "$1" = "0" ]; then
            echo "ERROR : Cannot remove the description"
        else
            local it=$1
            local im1=$((it))
            local ip1=$((it+2))
            local begin=1
            local end=${#func_desc[@]}
            if [ ! -z $BASH_SOURCE ]; then
                begin=0
            end=$((end-1))
            fi

            func_desc=(${func_desc[$begin,$im1]} ${func_desc[$ip1,$end]})


        # XXX il faudrait pouvoir supprimer les exemples sans tout supprimer
        #unset func_desc
        fi
    fi
}


set_desc(){
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


_add_opt(){
    opt_list+=($1)
    opt_desc+=("$2")
}


_remove_opt(){
    if [ -z ${opt_list+x} ] || [ -z ${opt_desc+x} ]; then
        echo "Error : Cannot remove option"
    else
        if ! _get_index $1; then return 1; fi
        local im1=$((index-1))
        local ip1=$((index+1))
        local begin=1
        local end=${#opt_list[@]}
        if [ ! -z $BASH_SOURCE ]; then
            begin=0
            end=$((end-1))
        fi

        opt_list=(${opt_list[$begin,$im1]} ${opt_list[$ip1,$end]})
        opt_desc=(${opt_desc[$begin,$im1]} ${opt_desc[$ip1,$end]})
    fi
}


set_opt_list(){
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






set_args(){
    local manual ll
    array=()
    for args in $@;
    do
        array+=("$args")
    done

    export _SET_DEFAULT_="1"
    if [ -z $BASH_SOURCE ]; then
        manual="$(find -L $PMNG/projects/enable -name ${array[1]}.param)"
        source $manual
    else
        manual="$(find -L $PMNG/projects/enable -name ${array[0]}.param)"
        source $manual
    fi
    unset _SET_DEFAULT_

    if [ -z $BASH_SOURCE ]; then
        for ((i=1; i<=${#array[@]}; i++))
        do
            _get_index_silent ${array[$i]}
            if [[ $index != 1000 ]]; then
                opt=$(echo ${opt_list[$((index))]} | sed 's/-/m/')
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

    if [ -z $BASH_SOURCE ]; then
        for ((i=1; i<=${#opt_list[@]}; i++))
        do
            ll=$(sed 's/-/m/g' <<< ${opt_list[$i]})
            if [ "${(P)ll}" = "REQUIRE" ]; then
                echo "ERROR : Missing parameter"
                ll=$(basename $manual)
                export _SOURCED_="1"
                func_man ${ll%.*}
                unset _SOURCED_
                return 1
            fi
        done
    else
        for ((i=0; i<${#opt_list[@]}; i++))
        do
            ll=$(sed 's/-/m/g' <<< ${opt_list[$i]})
            if [ "${!ll}" = "REQUIRE" ]; then
                echo "ERROR : Missing parameter"
                ll=$(basename $manual)
                export _SOURCED_="1"
                func_man ${ll%.*}
                unset _SOURCED_
                return 1
            fi
        done
    fi


    unset ptr_opt
    unset opt
    unset opt_desc
    unset opt_list
    unset func_desc

    return 0
}



test_set_params(){
    set_args $@
    echo $mtoto $mtutu $mtiti $mtata
}







