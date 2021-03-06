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

bold=$(tput bold)
normal=$(tput sgr0)

_is_project_enabled() {
    if [ -d "$PMNG/projects/enable/$1" ]; then
        return 0
    else
        return 1
    fi
}


_columnize_option () {
    local indent=$1;
    local size=$(($(tput cols)-indent));
    local option="$2";
    local value=$3;
    while [ $(echo -n $value| wc -c) -gt 0 ] ;
    do
        printf "        ";
        tput bold;
        printf "%-11s" "$option";
        tput sgr0;
        printf "%-${indent}s\n" "${value:0:$size}";
        option="";
        value=${value:$size};
    done
}

_columnize_example () {
    local indent=$1;
    local size=$(($(tput cols)-indent));
    local value=$2;
    local it=$3
    local symb="$ "
    while [ $(echo -n $value| wc -c) -gt 0 ] ;
    do
        printf "        ";
        if [ "$symb" = "$ " ]; then
            printf "($it) $symb";
        else
            printf "    $symb";
        fi
        printf "%-${indent}s\n" "${value:0:$size}";
        symb="  "
        value=${value:$size};
    done
}

_columnize_description () {
    local indent=$1;
    local size=$(($(tput cols)-indent));
    local value=$2;
    while [ $(echo -n $value| wc -c) -gt 0 ] ;
    do
        printf "        ";
        printf "%-${indent}s\n" "${value:0:$size}";
        value=${value:$size};
    done
}



_display_desc(){
    if [ -z ${func_desc+x} ]; then
        echo "Error : There is no description to display"
    else
        echo "${bold}DESCRIPTION${normal}"
        if [ -z $BASH_SOURCE ]; then
            _columnize_description 40 "${func_desc[1]}"
        else
            _columnize_description 40 "${func_desc[0]}"
        fi

        echo "${bold}EXAMPLE(S)${normal}"
        local iterator=1
        if [ -z $BASH_SOURCE ]; then
            for ((i=2; i<=${#func_desc[@]}; i++))
            do
                _columnize_example 40 "${func_desc[$i]}" $iterator
                ((iterator++))
            done
        else
            for ((i=1; i<${#func_desc[@]}; i++))
            do
                _columnize_example 40 "${func_desc[$i]}" $iterator
                ((iterator++))
            done
        fi
    fi
}


_display_opt(){
    if [ -z ${opt_list+x} ] || [ -z ${opt_desc+x} ]; then
        echo "Error : There is no option to display"
    else
        echo "${bold}OPTION(S)${normal}"
        if [ -z $BASH_SOURCE ]; then
            for ((i=1; i<=${#opt_list[@]}; i++))
            do
                _columnize_option 40 ${opt_list[$i]} ${opt_desc[$i]}
            done
        else
            for ((i=0; i<${#opt_list[@]}; i++))
            do
                _columnize_option 40 ${opt_list[$i]} "${opt_desc[$i]}"
            done
        fi
    fi
}

func_man(){
    local manual="$(find -L $PMNG/projects/available -name $1.param)"
    if [ ! "$manual" = "" ]; then
        local projectname=$(basename $(dirname "$manual"))
        if [ ! -L $PMNG/projects/enable/$projectname ]; then
            echo "(WARNING : This function appears in the project \"$projectname\" which is not enable)"
            echo ""
        fi
        if [ ! "$_SOURCED_" = "1" ]; then
            source $manual
        fi
        _display_desc
        _display_opt
        unset opt_list
        unset opt_desc
        unset func_desc
    else
        echo "There is no man entry for $1"
    fi
}


func_list(){
    local projectname
    local funcname
    local indent
    local size
    local option
    local value
    local state="enable"
    local mtype="enabled"

    if [ "$1" = "-all" ]; then
        state="available"
        mtype="all"
    elif [[ $# -ne 0 ]]; then
        echo "ERROR : Wrong parameter"
        return 1
    fi

    echo "${bold}List of $mtype functions${normal}"
    if [ "$1" = "-all" ]; then
        echo "(* = disabled function)"
    fi
    echo "Type \"scriptlet man function_name\" to see the manual."
    echo ""
    echo "${bold}Function          Project           Description${normal}"
    echo "${bold}-----------------------------------------------${normal}"
    for func in $(find -L $PMNG/projects/$state -name '*.param'); do
        source $func

        projectname=$(basename $(dirname "$func"))
        funcname=$(basename "$func")
        funcname="${funcname%.*}"


        indent=40;
        size=$(($(tput cols)-indent));

        if _is_project_enabled $projectname; then 
            option="$funcname";
        else
            option="*$funcname";
        fi

        if [ -z $BASH_SOURCE ]; then
            value="${func_desc[1]}"
        else
            value="${func_desc[0]}"
        fi
        if [ "$value" = "" ]; then 
            value="n/a"
        fi

        while [ $(echo -n $value| wc -c) -gt 0 ] ;
        do
            tput bold;
            printf "%-18s" "$option";
            tput sgr0;
            printf "%-18s" "$projectname";
            printf "%-${indent}s\n" "${value:0:$size}";
            option="";
            projectname="";
            value=${value:$size};
        done


        unset opt_list
        unset opt_desc
        unset func_desc
    done
    
}




