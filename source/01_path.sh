paths=(
  ~/.local/bin
  $DOTFILES/bin
  /usr/local/sbin
)

export PATH
for p in "${paths[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths
