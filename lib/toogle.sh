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

project() {
    if [ $# -ne "1" ] && [ $# -ne "2" ]; then
        echo "Usage: `basename $0` option [project_name]"
        echo "option :"
        echo "         show"
        echo "         enable  (project_name required)"
        echo "         disable (project_name required)"
    elif [ "$1" = "show" ]; then
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
    elif [ "$1" = "enable" ]; then
        if [ $# -ne "2" ]; then
            echo "Usage: `basename $0` enable plugin_name"
        else
            p=$2
            if [ ! -d "$PMNG/projects/enable/$p" ] && [ -d "$PMNG/projects/available/$p" ]; then
                ln -s $PMNG/projects/available/$p/ $PMNG/projects/enable/$p
                echo "Project $p enabled"
            else
                if [ -d "$PMNG/projects/enable/$p" ]; then
                    echo "Project already enabled"
                else
                    echo "Project not found"
                fi
            fi
        fi
    elif [ "$1" = "disable" ]; then
        if [ $# -ne "2" ]; then
            echo "Usage: `basename $0` disable project_name"
        else
            p=$2
            if [ -d "$PMNG/projects/enable/$p" ]; then
                unlink $PMNG/projects/enable/$p
                echo "Project $p disabled"
            else
                echo "Project not enabled"
            fi
        fi
    else
        echo "Usage: `basename $0` option [project_name]"
        echo "option :"
        echo "         show"
        echo "         enable  (project_name required)"
        echo "         disable (project_name required)"
    fi
}
