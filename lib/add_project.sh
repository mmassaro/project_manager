# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:

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

    local filename="foo"
    local projectname="foo"

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




    #cp $2 $PMNG/func/$1/core_$1.sh
    #if [ -n $3 ]; then
    #    if [ ! "$3" = "-folder" ]; then
    #        cp $3 $PMNG/func/$1/param_$1.sh
    #        sed -i 's/'"$3"'/$PMNG\/func\/'"$1"'\/param_'"$1"'.sh/g' $PMNG/func/$1/core_$1.sh
    #    else
    #        cp -r $4 $PMNG/func/$1/$4
    #        sed -i 's/'"$4"'/$PMNG\/func\/'"$1"'\/'"$4"'\//g' $PMNG/func/$1/core_$1.sh
    #    fi
    #fi

    #if [ -n $4 ] && [ "$4" = "-folder" ]; then
    #    cp -r $5 $PMNG/func/$1/$5
    #    sed -i 's/'"$5"'/$PMNG\/func\/'"$1"'\/'"$5"'\//g' $PMNG/func/$1/core_$1.sh
    #fi
}


