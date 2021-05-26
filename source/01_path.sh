#!/usr/bin/env bash

paths=(
  "$DOTFILES"/bin
  ~/.local/sbin
  ~/.local/bin
  ~/.cargo/bin
  ~/.cabal/bin
  ~/.ghcup/bin
  ~/bin
  /usr/local/sbin
  /usr/local/bin
  /opt/local/sbin
  /opt/local/bin
  /usr/sbin
  /usr/bin
  /sbin
  /bin
  /opt/gradle/gradle-5.5.1/bin
)

paths_rev=()

for p in "${paths[@]}"; do
  paths_rev=("$p" "${paths_rev[@]}")
done

export PATH
for p in "${paths_rev[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths paths_rev

if is_ubuntu; then
  linuxbrew=/home/linuxbrew/.linuxbrew/bin
  [[ -d "$linuxbrew" ]] && PATH="$linuxbrew:$(path_remove "$linuxbrew")"
  unset linuxbrew
fi
