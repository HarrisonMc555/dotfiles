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

# Make 'less' more.
[[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"
