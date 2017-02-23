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

  EDITOR="vim"
  PMNG=$PWD

  if [ -z $BASH_SOURCE ];then
    autoload bashcompinit
    bashcompinit
  fi


  for file in $PMNG/lib/*.sh;
  do
      source $PMNG/lib/$(basename $file);
  done


  for project in $(/bin/ls $PMNG/projects/enable);
  do
      for file in $PMNG/projects/enable/$project/*.sh;
      do
          source $PMNG/projects/enable/$project/$(basename $file);
      done
  done

  generate_param_file
  generate_autocomplete_file
}

main
