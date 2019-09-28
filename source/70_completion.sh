if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if is_osx; then
  # brew --prefix is kind of slow
  brew_prefix="$(dirname $(dirname $(type -p brew)))"
  export BASH_COMPLETION_COMPAT_DIR="${brew_prefix}/etc/bash_completion.d"
  # export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
  [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] &&
    . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

if is_available fzf; then
    fzf_completion="$(dirname $(dirname $(realpath $(which fzf))))/shell/completion.bash"
    [[ -f "$fzf_completion" ]] && source "$fzf_completion"
fi

# # SSH auto-completion based on entries in known_hosts.
# if is_available ssh && [[ -e ~/.ssh/known_hosts ]]; then
#   complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
# fi

# Use completions for commands to create completions for other commands
command_to_completion_commands=(
    "sshrc:ssh"
    "g:git"
    "s:svn"
    "em:ls"
    "l:ls"
    ""
)

for command_to_completion_command in "${command_to_completion_commands[@]}"; do
    IFS=':' read -r -a arr <<< "$command_to_completion_command"
    command="${arr[0]}"
    [[ "$command" ]] || continue
    is_available "$command" || continue
    completion_command="${arr[1]}"
    [[ "$completion_command" ]] || continue
    completion="$(complete -p "$completion_command" 2> /dev/null)" || continue
    completion_minus_completion_command="${completion%$completion_command}"
    new_completion="${completion_minus_completion_command}$command"
    eval "$new_completion"
done
