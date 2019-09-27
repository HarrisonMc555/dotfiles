if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if is_osx; then
  export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
  [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] &&
    . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi


# SSH auto-completion based on entries in known_hosts.
if is_available ssh && [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi

# Custom completions
ssh_completion="$(complete -p ssh)"
ssh_completion_minus_ssh="${ssh_completion%ssh}"
sshrc_completion="${ssh_completion_minus_ssh}sshrc"
eval "$sshrc_completion"
