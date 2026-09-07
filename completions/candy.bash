# bash completion for candy
#
# Installed to /usr/share/bash-completion/completions/candy and autoloaded by
# bash-completion on first <tab>. The subcommand list is queried from candy
# itself (candy --complete-commands) so it stays in sync automatically.

_candy() {
    local cur prev cmd
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # first word: complete the subcommand name
    if [ "$COMP_CWORD" -eq 1 ]; then
        local cmds
        cmds="$(candy --complete-commands 2>/dev/null)"
        mapfile -t COMPREPLY < <(compgen -W "$cmds" -- "$cur")
        return
    fi

    cmd="${COMP_WORDS[1]}"
    case "$cmd" in
        snapscreen)
            case "$prev" in
                -t|--type)
                    mapfile -t COMPREPLY < <(compgen -W "s w" -- "$cur")
                    return
                    ;;
            esac
            mapfile -t COMPREPLY < <(compgen -W "-t --type -h --help" -- "$cur")
            ;;
        topsize)
            case "$cur" in
                -*) mapfile -t COMPREPLY < <(compgen -W "-n -d -f -h --help" -- "$cur") ;;
                *)  mapfile -t COMPREPLY < <(compgen -d -- "$cur") ;;
            esac
            ;;
        same-size|move-videos|del-empty-dir)
            mapfile -t COMPREPLY < <(compgen -d -- "$cur")
            ;;
    esac
}
complete -F _candy candy
