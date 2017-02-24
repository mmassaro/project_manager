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

# extension="${filename##*.}"
# filename="${filename%.*}"

_is_project_exists() {
    if [ -d "$PMNG/projects/available/$1" ]; then
        echo "ERROR : The function $1 already exists"
        return 0
    else
        return 1
    fi
}


# XXX dans cette version, je ne modifie pas les path
import_project() {

    local filename
    local projectname

    if [[ $# -eq 1 ]]; then
        if [[ -d $1 ]]; then
            projectname=$(basename "$1")
            if _is_project_exists $projectname; then return 1; fi
            cp -r $1 $PMNG/projects/available/$projectname
        elif [[ -f $1 ]]; then
            filename=$(basename "$1")
            projectname=${filename%.*}
            if _is_project_exists $projectname; then return 1; fi
            mkdir $PMNG/projects/available/$projectname
            cp $1 $PMNG/projects/available/$projectname/$filename
        else
            echo "ERROR : Empty project"
            echo "DISPLAY MAN"
        fi
    elif [[ $# -ge 2 ]]; then
        if [[ ! -f "$1" ]] && [[ ! -d "$1" ]]; then
            projectname=$1
            if _is_project_exists $projectname; then return 1; fi
            mkdir $PMNG/projects/available/$projectname
            if [[ $# -eq 2 ]] && [[ -d "$2" ]]; then
                cp $2/* $PMNG/projects/available/$projectname/
            else
                if [ -z $BASH_SOURCE ]; then
                    for ((i=2; i<=$#; i++))
                    do
                        if [ -d ${@[$i]} ] || [ -f ${@[$i]} ]; then
                            cp -r ${@[$i]} $PMNG/projects/available/$projectname/
                        fi
                    done
                else
                    for ((i=2; i<$#; i++))
                    do
                        if [ -d ${@[$i]} ] || [ -f ${@[$i]} ]; then
                            cp -r ${@[$i]} $PMNG/projects/available/$projectname/
                        fi
                    done
                fi
            fi
        elif [[ -d  "$1" ]]; then
            projectname=$1
            if _is_project_exists $projectname; then return 1; fi
            mkdir $PMNG/projects/available/$projectname
            if [ -z $BASH_SOURCE ]; then
                for ((i=1; i<=$#; i++))
                do
                    if [ -d ${@[$i]} ] || [ -f ${@[$i]} ]; then
                        cp -r ${@[$i]} $PMNG/projects/available/$projectname/
                    fi
                done
            else
                for ((i=0; i<$#; i++))
                do
                    if [ -d ${@[$i]} ] || [ -f ${@[$i]} ]; then
                        cp -r ${@[$i]} $PMNG/projects/available/$projectname/
                    fi
                done
            fi
        else
            filename=$(basename "$1")
            projectname=${filename%.*}
            if _is_project_exists $projectname; then return 1; fi
            mkdir $PMNG/projects/available/$projectname
            if [ -z $BASH_SOURCE ]; then
                for ((i=1; i<=$#; i++))
                do
                    if [ -d ${@[$i]} ] || [ -f ${@[$i]} ]; then
                        cp -r ${@[$i]} $PMNG/projects/available/$projectname/
                    fi
                done
            else
                for ((i=0; i<$#; i++))
                do
                    if [ -d ${@[$i]} ] || [ -f ${@[$i]} ]; then
                        cp -r ${@[$i]} $PMNG/projects/available/$projectname/
                    fi
                done
            fi
        fi
    else
        echo "ERROR : No argument"
        echo "DISPLAY MAN"
    fi

}

# TODO check the validity
download_project() {
    local directory=$(basename "$1")
    git clone https://github.com/$1 $PMNG/projects/available/$directory
}
