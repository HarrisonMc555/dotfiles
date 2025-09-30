#!/usr/bin/env bash

# An open-source tool to view Jira from the command line
# URL: https://github.com/ankitpokhrel/jira-cli
if is_available jira; then

    # This method and the __jira_list_helper method are a work-around for
    # https://github.com/ankitpokhrel/jira-cli/issues/760. They add a `--jql
    # "project IS NOT EMPTY"` JQL to any "jira issue list" invocation, but leave
    # other commands untouched.
    function __jira_helper() {
        local command sub_command is_previous_flag

        for arg in "$@"; do
            if [[ "$is_previous_flag" ]]; then
                is_previous_flag=
                continue
            fi
            case "$arg" in
                -h|--help) ;;
                -*) is_previous_flag=true;;
                *)
                    if [[ "$subcommand" ]]; then
                        :
                    elif [[ "$command" ]]; then
                        sub_command="$arg"
                        break
                    else
                        command="$arg"
                    fi
                    ;;
            esac
        done

        case "$command" in
            issue|issues)
                case "$sub_command" in
                    list|lists|ls|search)
                        __jira_list_helper "$@"
                        return $?
                        ;;
                esac
                ;;
        esac

        jira "$@"
    }
    
    # This method is a work-around for
    # https://github.com/ankitpokhrel/jira-cli/issues/760. It adds a `--jql
    # "project IS NOT EMPTY"` JQL argument OR adds a `--jql project IS NOT EMPTY
    # AND (<provided_jql_argument>)` if a -q/--jql flag was provided.
    function __jira_list_helper() {
        args=()
        for arg in "$@"; do
            if [[ "$previous_is_jql" ]]; then
                jql_arg="$arg"
                previous_is_jql=
            else
                case "$arg" in
                    -q|--jql) previous_is_jql=true;;
                    *) args+=("$arg");;
                esac
            fi
        done

        if [[ "$jql_arg" ]]; then
            total_jql_arg="project IS NOT EMPTY AND (${jql_arg})"
        else
            total_jql_arg="project IS NOT EMPTY"
        fi
        jira "${args[@]}" --jql "$total_jql_arg"
    }

    ## This is an example of how to work with multiple Jira servers. Define a
    ## function for each Jira server that will export the appropriate API token
    ## environment variable, use the appropriate configuration file, and call
    ## the __jira_helper method. Then, add the appropriate completions for your
    ## new functions.

    # # Run `jira init`, and then copy ~/.config/.jira/.config.yml to,
    # # e.g., ~/.config/.jira/foo.config.yml
    # function foo-jira() {
    #     JIRA_API_TOKEN=$(cat ~/path/to/jira-foo-token.txt)
    #     export JIRA_API_TOKEN
    #     __jira_helper --config ~/.config/.jira/foo.config.yml "$@"
    # }

    # function bar-jira() {
    #     JIRA_API_TOKEN=$(cat ~/path/to/jira-bar-token.txt)
    #     export JIRA_API_TOKEN
    #     __jira_helper --config ~/.config/.jira/bar.config.yml "$@"
    # }

    # # Run `jira completion bash` and save it to a file.
    # source ~/path/to/jira/completion/file
    # if [[ $(type -t compopt) = "builtin" ]]; then
    #     complete -o default -F __start_jira foo-jira
    #     complete -o default -F __start_jira bar-jira
    # else
    #     complete -o default -o nospace -F __start_jira foo-jira
    #     complete -o default -o nospace -F __start_jira bar-jira
    # fi
fi
