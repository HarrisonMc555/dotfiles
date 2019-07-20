paths=(
  ~/bin
  ~/.local/bin
  "$DOTFILES"/bin
  /usr/local/sbin
  "$HOME"/.cargo/bin
)

export PATH
for p in "${paths[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths
