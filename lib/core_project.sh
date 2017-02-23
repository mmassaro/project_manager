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

# XXX check parameter
# XXX add import
# XXX security for remove project
# XXX faire des petites fonctions
# XXX parametre locaux

_check_project_args() {
    echo "A faire"
    retrun $2
}

_print_usage(){
    echo "Usage: `basename $1` option [project_name]"
    echo "option :"
    echo "         show"
    echo "         enable  (project_name required)"
    echo "         disable (project_name required)"
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
    if [ -f "$PMNG/available/$1/README.md" ]; then
        less $PMNG/available/$1/README.md
    else
        echo "There is no man for $1"
    fi
}

_project_add() {
    echo "A faire"
}


_project_remove() {
    if [ -d "$PMNG/available/$1" ]; then
        rm -rf $PMNG/available/$1
    fi
}


# faire un case
project() {

    if ! _check_project_args $@; then _print_usage $0; return 1; fi

    if [ "$1" = "show" ]; then
        _project_show
    elif [ "$1" = "enable" ]; then
        _project_enable $2
    elif [ "$1" = "disable" ]; then
        _project_disable $2
    elif [ "$1" = "man" ]; then
        _project_man $2
    elif [ "$1" = "add" ]; then
        _project_add
    elif [ "$1" = "remove" ]; then
        _project_remove $2
    fi

    return 0
}
