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


