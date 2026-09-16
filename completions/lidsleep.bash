# bash completion for lidsleep

_lidsleep() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    case $COMP_CWORD in
        1) mapfile -t COMPREPLY < <(compgen -W 'on off toggle status reset help version' -- "$cur") ;;
        2) case ${COMP_WORDS[1]} in
               on|off|toggle) mapfile -t COMPREPLY < <(compgen -W '--permanent -p' -- "$cur") ;;
           esac ;;
    esac
}

complete -F _lidsleep lidsleep
