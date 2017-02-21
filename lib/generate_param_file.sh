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


# encore pas mal de restriction.
# il faut que les commentaires soit au debut
# pas de valeurs pas defaut
_generate_param_function() {

  local dir=$(dirname "$2")

  if [ ! -f "$dir/$1.param" ]; then

    echo "# Set the description of the function" > $dir/$1.param
    line=$(sed -n '/'"$1"'()/,/^[^#]/p' $2 | grep description)
    line=$(sed 's/\#[[:space:]]description[[:space:]]:[[:space:]]//g' <<< $line)
    if [ "$line" = "" ]; then
      rm $dir/$1.param
      return 0
    else
      echo "set_desc add $line" >> $dir/$1.param
    fi

    echo "" >> $dir/$1.param
    echo "# Set the list of example" >> $dir/$1.param
    sed -n '/'"$1"'()/,/^[^#]/p' $2 | grep example > tmp
    while IFS='' read -r line || [[ -n "$line"  ]]; do
      line=$(sed 's/\#[[:space:]]example[[:space:]]:[[:space:]]//g' <<< $line)
      echo "set_desc add $line" >> $dir/$1.param
    done < "tmp"

    echo "" >> $dir/$1.param
    echo "# Set the list of options with description" >> $dir/$1.param
    sed -n '/'"$1"'()/,/^[^#]/p' $2 | grep option > tmp
    while IFS='' read -r line || [[ -n "$line"  ]]; do
      line=$(sed 's/\#[[:space:]]option[[:space:]]:[[:space:]]//g' <<< $line)
      echo "set_opt_list add $line" >> $dir/$1.param
    done < "tmp"

    echo "" >> $dir/$1.param
    echo "if [ "\$_SET_DEFAULT_" = "1" ]; then" >> $dir/$1.param
    echo "  # Set default values to the options." >> $dir/$1.param

    sed -n '/'"$1"'()/,/^[^#]/p' $2 | grep option > tmp
    while IFS='' read -r line || [[ -n "$line"  ]]; do
      ll=$(sed 's/\#[[:space:]]option[[:space:]]:[[:space:]]//g' <<< $line)
      ll=$(sed 's/[[:space:]].*//' <<< $ll)
      ll=$(sed 's/-/m/' <<< $ll)
      line=$(sed 's/^.*DEFAULT[[:space:]]=[[:space:]]//g' <<< $line)
      echo "  $ll=$line" >> $dir/$1.param
    done < "tmp"
    echo "fi" >> $dir/$1.param

    rm tmp

    #sed -i '/sed -n/d' $dir/$1.param
  fi

}


generate_param_file() {

  for file in $(find -L $PMNG/projects/enable -name '*.sh'); do

    local func

    cat $file | grep "\#[[:space:]]function_name" > tmp2
    #sed -i '/cat/d' tmp2
    #sed -i '/space/d' tmp2
    while IFS='' read -r func || [[ -n "$func"  ]]; do
      func=$(sed 's/\#[[:space:]]function_name[[:space:]]:[[:space:]]//g' <<< $func)
      _generate_param_function "$func" "$file"
    done < "tmp2"

    rm tmp2


  done

}
