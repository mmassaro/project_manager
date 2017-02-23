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

scriptlets(){

    if [ "$1" = "new" ]; then
        touch $PMNG/projects/available/scriptlets/src/$2.sh

        echo "$2() { " >> $PMNG/projects/available/scriptlets/src/$2.sh
        echo "" >> $PMNG/projects/available/scriptlets/src$2.sh
        echo "  # function_name : $2" >> $PMNG/projects/available/scriptlets/src/$2.sh
        echo "  # description : \"\"" >> $PMNG/projects/available/scriptlets/src/$2.sh
        echo "  # example : \"\"" >> $PMNG/projects/available/scriptlets/src/$2.sh
        echo "  # option : \"-h\" \"\" DEFAULT = \"\"" >> $PMNG/projects/available/scriptlets/src/$2.sh
        echo "" >> $PMNG/projects/available/scriptlets/src/$2.sh
        echo "}" >> $PMNG/projects/available/scriptlets/src$2.sh
        echo "" >> $PMNG/projects/available/scriptlets/src$2.sh
        echo "" >> $PMNG/projects/available/scriptlets/src/$2.sh


        $EDITOR $PMNG/projects/available/scriptlets/src/$2.sh

    fi
}
