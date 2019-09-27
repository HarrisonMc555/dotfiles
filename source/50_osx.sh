# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Add paths to beginning
paths_rev=(
    /usr/local/bin
    /usr/local/opt/coreutils/libexec/gnubin
)

paths=()

for p in "${paths_rev[@]}"; do
  paths=("$p" "${paths[@]}")
done

for p in "${paths[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths paths_rev

export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
[[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias lock="open -a ScreenSaverEngine"

alias cask="brew cask"

export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] &&
    . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
