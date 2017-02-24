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

_check_project_contains(){
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

_check_project_args() {
    local available_mode
    local current_mode

    if [ ! "$1" = "" ]; then
        available_mode=("show" "enable" "disable" "man" "add" "remove")
        if ! _check_project_contains "$1" ${available_mode[@]}; then return 1; fi

        current_mode=("enable" "disable" "remove" "man")
        if _check_project_contains "$1" ${current_mode[@]}; then 
            if [ "$2" = "" ] || [ ! "$3" = "" ]; then return 1; fi
        fi

        current_mode=("show")
        if _check_project_contains "$1" ${current_mode[@]}; then 
            if [ ! "$2" = "" ]; then return 1; fi
        fi
    else
        _print_usage "project"
        return 1
    fi

    echo "A faire"
    return 0
}

_print_usage(){
    echo "Usage: `basename $1` option [project_name]"
    echo "option :"
    echo "         add     (project_name and project required)"
    echo "         disable (project_name required)"
    echo "         enable  (project_name required)"
    echo "         man     (project_name required)"
    echo "         remove  (project_name required)"
    echo "         show"
}

_project_show() {
    local description
    local is_enable
    local p

    printf "\nList of projects\n"
    echo "---------------------"
    printf "%-12s%-25s%s\n" 'Enabled ?' 'Project' 'Description'
    printf "\n"
    for project in $PMNG/projects/available/*; do
        p=$(basename $project)
        if [ -f "$project/README.md" ]; then
            description=$(cat "$project/README.md" | grep 'project-description' | sed 's/\#[[:space:]]project-description[[:space:]]:[[:space:]]//')
        else
            description="Description unreadable. File name no standart"
        fi
        if [ -d $PMNG/projects/enable/$p ]; then
            is_enable="X"
        else
            is_enable=" "
        fi
        printf "%-12s%-25s%s\n" "[$is_enable]" "$p" "$description"
    done
}


_project_enable() {
    if [ ! -d "$PMNG/projects/enable/$1" ] && [ -d "$PMNG/projects/available/$1" ]; then
        ln -s $PMNG/projects/available/$1/ $PMNG/projects/enable/$1
        echo "Project $1 enabled"
    else
        if [ -d "$PMNG/projects/enable/$1" ]; then
            echo "Project already enabled"
        else
            echo "Project not found"
        fi
    fi
}

_project_disable() {
    if [ -d "$PMNG/projects/enable/$1" ]; then
        unlink $PMNG/projects/enable/$1
        echo "Project $1 disabled"
    else
        echo "Project not enabled"
    fi

}

_project_man() {
    if [ -f "$PMNG/projects/available/$1/README.md" ]; then
        less $PMNG/projects/available/$1/README.md
    else
        echo "There is no man for $1"
    fi
}

_project_add() {
    import_project $@
}


_project_remove() {
    local answer
    if [ -d "$PMNG/projects/available/$1" ]; then
        read -p "Are you sure ? [Y/n] : " answer
        answer=${answer:-Y}
        if [ "$answer" = "Y" ]; then
            rm -rf $PMNG/projects/available/$1
        elif [ ! "$answer" = "n" ]; then
            echo "Consider it's no ..."
        fi
    else
        echo "Project $1 not found"
    fi
}


project() {
    if ! _check_project_args $@; then _print_usage $0; return 1; fi

    case $1 in
      show) _project_show;;
      enable) _project_enable $2;;
      disable) _project_disable $2;;
      man)  _project_man $2;;
      add)  _project_add ${@:2};;
      remove)  _project_remove $2
    esac

    return 0
}
