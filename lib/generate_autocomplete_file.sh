#                                      _
#                      _o)   __ _  ___/ /__  __ _  (o_
####################   /\\  /  ' \/ _  / _ `/  ' \ //\   #####################
#                      \_v /_/_/_/\_,_/\_, /_/_/_/ v_/
#                                     /___/
#
# Author:       Michel Massaro
# Version :     V0.1
# Date :        30/01/17
# Description : projet for latex
#
##############################################################################

_generate_autocomplete_function() {

  local args ll

  echo "_$1() {" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "  local cur prev opts" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "  COMPREPLY=()" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "  cur=\"\${COMP_WORDS[COMP_CWORD]}\"" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "  prev=\"\${COMP_WORDS[COMP_CWORD-1]}\"" >> $PMNG/projects/enable/$2/autocomplete.sh


  args=""
  sed -n '/'"$1"'()/,/^[^#]/p' $3 | grep option > tmp
    while IFS='' read -r line || [[ -n "$line"  ]]; do
      ll=$(sed 's/\#[[:space:]]option[[:space:]]:[[:space:]]//g' <<< $line)
      ll=$(sed 's/[[:space:]].*//' <<< $ll)
      args="$args $ll"
    done < "tmp"

  echo "  opts=\"$args\"" >> $PMNG/projects/enable/$2/autocomplete.sh

  echo "  COMPREPLY=( \$(compgen -W \"\$opts\" \${cur}) )" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "  return 0" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "}" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "complete -F _$1 -o default $1" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "" >> $PMNG/projects/enable/$2/autocomplete.sh
  echo "" >> $PMNG/projects/enable/$2/autocomplete.sh

  rm tmp
}

generate_autocomplete_file() {

  for project in $(/bin/ls $PMNG/projects/enable); do

    if [ ! -f $PMNG/projects/enable/$project/autocomplete.sh ]; then

      for file in $(find -L $PMNG/projects/enable/$project -name '*.sh'); do

        cat $file | grep "\#[[:space:]]function_name" > tmp2
        while IFS='' read -r func || [[ -n "$func"  ]]; do
          func=$(sed 's/\#[[:space:]]function_name[[:space:]]:[[:space:]]//g' <<< $func)
          _generate_autocomplete_function $func $project $file
        done < "tmp2"

        rm tmp2

      done


    fi







    done

}
