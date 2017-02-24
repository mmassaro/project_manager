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

_generate_autocomplete_function() {

  local args ll
  local state="enable"
  if [ "$4" = "-all" ]; then
    state="available"
  fi

  echo "_$1() {" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "  local cur prev opts" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "  COMPREPLY=()" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "  cur=\"\${COMP_WORDS[COMP_CWORD]}\"" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "  prev=\"\${COMP_WORDS[COMP_CWORD-1]}\"" >> $PMNG/projects/$state/$2/autocomplete.sh


  args=""
  sed -n '/'"$1"'()/,/^[^#]/p' $3 | grep option > tmp
  while IFS='' read -r line || [[ -n "$line"  ]]; do
    ll=$(sed 's/\#[[:space:]]option[[:space:]]:[[:space:]]//g' <<< $line)
    ll=$(sed 's/[[:space:]].*//' <<< $ll)
    args="$args $ll"
  done < "tmp"

  echo "  opts=\"$args\"" >> $PMNG/projects/$state/$2/autocomplete.sh

  echo "  COMPREPLY=( \$(compgen -W \"\$opts\" \${cur}) )" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "  return 0" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "}" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "complete -F _$1 -o default $1" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "" >> $PMNG/projects/$state/$2/autocomplete.sh
  echo "### DO NOT DELETE ###" >> $PMNG/projects/$state/$2/autocomplete.sh

  rm tmp
}

generate_autocomplete_file() {

  for project in $(/bin/ls $PMNG/projects/enable); do

    if [ ! -f $PMNG/projects/enable/$project/autocomplete.sh ]; then
      touch $PMNG/projects/enable/$project/autocomplete.sh
    fi

    #for file in $(find -L $PMNG/projects/enable/$project -name '[^autocomplete]*.sh'); do
    for file in $(find -L $PMNG/projects/enable/$project -name '*.sh'); do

      local func=""

      cat $file | grep "\#[[:space:]]function_name" > tmp3
      while IFS='' read -r func || [[ -n "$func" ]]; do
        func=$(sed 's/\#[[:space:]]function_name[[:space:]]:[[:space:]]//g' <<< $func)
        if [ "$(grep  "_$func()" $PMNG/projects/enable/$project/autocomplete.sh)" = "" ]; then
            _generate_autocomplete_function $func $project $file
        fi
      done < "tmp3"
      rm tmp3

    done

  done

}
