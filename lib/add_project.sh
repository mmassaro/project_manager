# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:



import_function() {
    if [ -d $PMNG/projects/available/$1 ]; then
        echo "ERROR : The function $1 already exists"
        return 1
    fi

    if [[ $# -eq 1 ]]; then
        if [[ -d $1 ]]; then
            cp -r $1 $PMNG/projects/available/$1
        else
            echo "ERROR : Empty project or empty project name"
            echo "DISPLAY MAN"
        fi;
    elif [[ $# -eq 2 ]] && [[ -d $2 ]] && [[ ! -d $1 ]] && [[ ! -f $1 ]]; then
        if [[ -d $2 ]]; then
            mkdir $PMNG/project/available/$1
            cp $2/* $PMNG/projects/available/$1/
        elif [[ -f $2 ]]; then
            mkdir $PMNG/project/available/$1
            cp $2 $PMNG/projects/available/$1/
        else
            echo "pas bon"
        fi
    elif [[ $# -gt 0 ]]; then
        echo "toto"
    else
        echo "ERROR : "
    fi




    cp $2 $PMNG/func/$1/core_$1.sh
    if [ -n $3 ]; then
        if [ ! "$3" = "-folder" ]; then
            cp $3 $PMNG/func/$1/param_$1.sh
            sed -i 's/'"$3"'/$PMNG\/func\/'"$1"'\/param_'"$1"'.sh/g' $PMNG/func/$1/core_$1.sh
        else
            cp -r $4 $PMNG/func/$1/$4
            sed -i 's/'"$4"'/$PMNG\/func\/'"$1"'\/'"$4"'\//g' $PMNG/func/$1/core_$1.sh
        fi
    fi

    if [ -n $4 ] && [ "$4" = "-folder" ]; then
        cp -r $5 $PMNG/func/$1/$5
        sed -i 's/'"$5"'/$PMNG\/func\/'"$1"'\/'"$5"'\//g' $PMNG/func/$1/core_$1.sh
    fi
}


