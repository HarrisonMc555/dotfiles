_flamegraph() {
    local i cur prev opts cmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${i}" in
            "$1")
                cmd="flamegraph"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        flamegraph)
            opts="-h -V -p -v -o -F -c -i --help --version --pid --completions --verbose --output --open --root --freq --cmd --deterministic --inverted --reverse --notes --min-width --image-width --palette --flamechart --no-inline --perfdata <TRAILING_ARGUMENTS>..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --pid)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --completions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -o)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --freq)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -F)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cmd)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --notes)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --min-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --image-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --palette)
                    COMPREPLY=($(compgen -W "hot mem io red green blue aqua yellow purple orange wakeup java perl js rust" -- "${cur}"))
                    return 0
                    ;;
                --perfdata)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

complete -F _flamegraph -o bashdefault -o default flamegraph
