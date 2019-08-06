paths=(
  ~/bin
  ~/.local/bin
  ~/.local/sbin
  "$DOTFILES"/bin
  /usr/local/sbin
  /usr/local/bin
  "$HOME"/.cargo/bin
  /opt/gradle/gradle-5.5.1/bin
)

export PATH
for p in "${paths[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths
