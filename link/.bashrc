# Exit if not interactive
if [[ $- != *i* ]]; then
    path_script="$DOTFILES/source/01_path.sh"
    if [[ -f "$path_script" ]]; then
        source "$path_script"
    fi
    return
fi

# Where the magic happens.
export DOTFILES=~/.dotfiles

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in "$DOTFILES"/source/*.sh; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  "$DOTFILES"/bin/dotfiles "$@" && src
}

src
