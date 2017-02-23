# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:
#
#                                   _      _
#                   _o)   __ _  ___/ /__ _/ /_  __ _  (o_
#################   /\\  /  ' \/ _  / _ `/ _  \/  ' \ //\   ##################
#                   \_v /_/_/_/\_,_/\_, /_/ /_/_/_/_/ v_/
#                                  /___/
#
# Author:       Michel Massaro
# Version :     V0.1
# Date :        30/01/17
# Description : projet for latex
#
##############################################################################

_scriptlets_init() {

    if [ -! -d  "$PMNG/projects/available/scriptlets" ]; then
        mkdir $PMNG/projects/available/scriptlets
        mkdir $PMNG/projects/available/scriptlets/src
    fi

}

scriptlets(){

    if [ "$1" = "new" ]; then

        _scriptlets_init

        echo "$2() { " >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "# function_name : $2" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "# description : \"\"" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "# example : \"\"" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "# option : \"\" \"\" DEFAULT = \"\"" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "}" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet
        echo "" >> $PMNG/projects/available/scriptlets/src/$2.scriptlet


        $EDITOR $PMNG/projects/available/scriptlets/src/$2.scriptlet

        cat $PMNG/projects/available/scriptlets/src/$2.scriptlet >> $PMNG/projects/available/scriptlets/scriptlets.sh

        local file=$PMNG/projects/available/scriptlets/scriptlets.sh
        cat  $file | grep "\#[[:space:]]function_name" > tmp2
        while IFS='' read -r func || [[ -n "$func" ]]; do
            func=$(sed 's/\#[[:space:]]function_name[[:space:]]:[[:space:]]//g' <<< $func)
            _generate_param_function "$func" "$file"
            if [ "$(grep  "_$func()" $PMNG/projects/enable/$project/autocomplete.sh)" = "" ]; then
                _generate_autocomplete_function $func "scriptlets" $file
            fi
        done < "tmp2"
        rm tmp2

    elif [ "$1" = "revise" ]; then

        _scriptlets_init

        # XXX redo without deleting scriptlets.sh
        $EDITOR $PMNG/projects/available/scriptlets/src/$2.scriptlet

        rm $PMNG/projects/available/scriptlets/scriptlets.sh
        cat $PMNG/projects/available/scriptlets/src/*.scriptlet >> $PMNG/projects/available/scriptlets/scriptlets.sh

        local file=$PMNG/projects/available/scriptlets/scriptlets.sh
        _generate_autocomplete_function $2 "scriptlets" $file
        _generate_param_function "$2" "$file"

    fi
}
