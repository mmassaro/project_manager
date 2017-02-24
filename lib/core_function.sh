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

_scriptlets_init() {

    if [ ! -d  "$PMNG/projects/available/misc" ]; then
        mkdir $PMNG/projects/available/misc
        touch $PMNG/projects/available/misc/misc.sh
        touch $PMNG/projects/available/misc/autocomplete.sh
        mkdir $PMNG/projects/available/misc/src
    elif [ ! -d  "$PMNG/projects/available/misc/src" ]; then
        mkdir $PMNG/projects/available/misc/src
    fi
}


_check_scriptlet_contains(){
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

_check_scriptlet_args() {
    local available_mode
    local current_mode

    if [ ! "$1" = "" ]; then
        available_mode=("show" "add" "remove" "man" "revise")
        if ! _check_project_contains "$1" ${available_mode[@]}; then return 1; fi
    else
        _print_scriptlet_usage "scriptlets"
        return 1
    fi
    return 0
}

_print_scriptlet_usage(){
    echo "Usage: `basename $1` option [project_name]"
    echo "option :"
    echo "         add mics (scriptlet_name or file required)"
    echo "         man     (scriptlet_name required)"
    echo "         remove misc (scriptlet_name required)"
    echo "         revise misc (scriptlet_name required)"
    echo "         show"
}

_scriptlet_show() {
    func_list $@
}

_scriptlet_man(){
    func_man $@
}

_scriptlet_add(){
    _scriptlets_init

    echo "$2() { " >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "# function_name : $2" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "# description : \"\"" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "# example : \"\"" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "# option : \"\" \"\" DEFAULT = \"\"" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "}" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "" >> $PMNG/projects/available/misc/src/$2.scriptlet
    echo "### DO NOT DELETE ###" >> $PMNG/projects/available/misc/src/$2.scriptlet


    $EDITOR $PMNG/projects/available/misc/src/$2.scriptlet

    cat $PMNG/projects/available/misc/src/$2.scriptlet >> $PMNG/projects/available/misc/misc.sh

    local file=$PMNG/projects/available/misc/misc.sh
    cat  $file | grep "\#[[:space:]]function_name" > tmp2
    while IFS='' read -r func || [[ -n "$func" ]]; do
        func=$(sed 's/\#[[:space:]]function_name[[:space:]]:[[:space:]]//g' <<< $func)
        _generate_param_function "$func" "$file"
        if [ "$(grep  "_$func()" $PMNG/projects/available/misc/autocomplete.sh)" = "" ]; then
            _generate_autocomplete_function $func "misc" $file "-all"
        fi
    done < "tmp2"
    rm tmp2
}

_scriptlet_revise(){
    $EDITOR $PMNG/projects/available/$1/src/$2.scriptlet


    sed -i '/'"$2"'\(\)/,/^\#\#\#[[:space:]]DO[[:space:]]NOT[[:space:]]DELETE[[:space:]]\#\#\#$/d' $PMNG/projects/available/$1/misc.sh
    sed -i '/_'"$2"'\(\)/,/^\#\#\#[[:space:]]DO[[:space:]]NOT[[:space:]]DELETE[[:space:]]\#\#\#$/d' $PMNG/projects/available/$1/autocomplete.sh
    rm $PMNG/projects/available/$1/$2.param
    cat $PMNG/projects/available/$1/src/$2.scriptlet >> $PMNG/projects/available/$1/misc.sh

    local file=$PMNG/projects/available/$1/misc.sh
    _generate_autocomplete_function $2 $1 $file "-all"
    _generate_param_function "$2" "$file"
}

_scriptlet_remove(){
    rm $PMNG/projects/available/$1/src/$2.scriptlet
    rm $PMNG/projects/available/$1/$2.param

    sed -i '/'"$2"'\(\)/,/^\#\#\#[[:space:]]DO[[:space:]]NOT[[:space:]]DELETE[[:space:]]\#\#\#$/d' $PMNG/projects/available/$1/misc.sh
    sed -i '/_'"$2"'\(\)/,/^\#\#\#[[:space:]]DO[[:space:]]NOT[[:space:]]DELETE[[:space:]]\#\#\#$/d' $PMNG/projects/available/$1/autocomplete.sh
}









scriptlet() {
    if ! _check_scriptlet_args $@; then _print_scriptlet_usage $0; return 1; fi

    case $1 in
      show) _scriptlet_show ${@:2};;
      man)  _scriptlet_man ${@:2};;
      add) _scriptlet_add ${@:2};;
      revise) _scriptlet_revise ${@:2};;
      remove)  _scriptlet_remove ${@:2}
    esac

    return 0
}
