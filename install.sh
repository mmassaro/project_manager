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

main(){

  PMNG=$PWD

  if [ -z $BASH_SOURCE ];then
    autoload bashcompinit
    bashcompinit
  fi

  source ./lib/toogle.sh
  source ./lib/add_project.sh
  source ./lib/display_projects.sh
  source ./lib/generate_param_file.sh
  source ./lib/generate_autocomplete_file.sh
  source ./lib/args_manager.sh

  for f in $(/bin/ls $PMNG/projects/enable);
  do
    source $PMNG/projects/enable/$f/*.sh;
  done

  generate_param_file
  generate_autocomplete_file
}

main
