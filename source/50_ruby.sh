#!/usr/bin/env bash

if [[ -e /etc/profile.d/rvm.sh ]]; then
    # rvm init
    # shellcheck disable=SC1091
    source /etc/profile.d/rvm.sh
fi

if is_available rbenv; then
    eval "$(rbenv init -)"
elif [[ -d "$HOME/.rbenv/" ]]; then
    export PATH="$HOME/.rbenv/shims:$PATH"
fi

ls_alias=$(alias ls)
ls_alias="${ls_alias#alias ls=\'}"
ls_alias="${ls_alias%\'}"
unalias ls
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
# shellcheck disable=SC2139
alias ls="$ls_alias"
