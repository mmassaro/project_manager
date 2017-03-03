_project() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="add disable enable man remove show"

    opts_disable=""
    for ll in $(/bin/ls $PMNG/projects/enable); do
        opts_disable="$opts_disable $ll";
    done

    opts_enable=""
    for ll in $(/bin/ls $PMNG/projects/available); do
        if [ ! -d "$PMNG/projects/enable/$ll" ]; then
            opts_enable="$opts_enable $ll";
        fi
    done

    opts_man_remove=""
    for ll in $(/bin/ls $PMNG/projects/available); do
        opts_man_remove="$opts_man_remove $ll";
    done

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        case $prev in
            disable) COMPREPLY=( $(compgen -W  "$opts_disable" -- ${cur}) );;
            enable) COMPREPLY=( $(compgen -W "$opts_enable" -- ${cur}) );;
            man) COMPREPLY=( $(compgen -W "$opts_man_remove" -- ${cur}) );;
            remove) COMPREPLY=( $(compgen -W "$opts_man_remove" -- ${cur}) );;
        esac
    fi
  return 0
}

complete -F _project -o default project



_scriptlet() {
    local cur prev prevprev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="add man remove revise show"

    opts_man=""
    for ll in $(find $PMNG/projects/available -name "*.param"); do
      ll=$(basename $ll)
      ll="${ll%.*}"
      opts_man="$opts_man $ll";
    done

    opts_add="misc"
    opts_revise="misc"
    opts_remove="misc"

    opts_show="-all"

    if [[ $COMP_CWORD -eq 3 ]]; then
      prevprev="${COMP_WORDS[COMP_CWORD-2]}"

      opts_revise2=""
      for ll in $(find $PMNG/projects/available/$prev -name "*.param"); do
        ll=$(basename $ll)
        ll="${ll%.*}"
        opts_revise2="$opts_revise2 $ll";
      done

      opts_remove2=""
      for ll in $(find $PMNG/projects/available/$prev -name "*.param"); do
        ll=$(basename $ll)
        ll="${ll%.*}"
        opts_remove2="$opts_revise2 $ll";
      done
    fi




    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        case $prev in
            man) COMPREPLY=( $(compgen -W  "$opts_man" -- ${cur}) );;
            add) COMPREPLY=( $(compgen -W  "$opts_add" -- ${cur}) );;
            revise) COMPREPLY=( $(compgen -W  "$opts_revise" -- ${cur}) );;
            remove) COMPREPLY=( $(compgen -W  "$opts_remove" -- ${cur}) );;
            show) 
                if [[ ${cur} == -*  ]] ; then
                   COMPREPLY=( $(compgen -W "$opts_show" -- ${cur}) )
                 else
                   COMPREPLY=()
                 fi;;
        esac
    elif [[ $COMP_CWORD -eq 3 ]]; then
        case $prevprev in
            revise) COMPREPLY=( $(compgen -W  "$opts_revise2" -- ${cur}) );;
            remove) COMPREPLY=( $(compgen -W  "$opts_remove2" -- ${cur}) );;
        esac
    fi
  return 0
}

complete -F _scriptlet -o default scriptlet


