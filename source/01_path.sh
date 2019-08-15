paths=(
  /opt/gradle/gradle-5.5.1/bin
  ~/.cargo/bin
  /usr/local/sbin
  /usr/local/bin
  ~/bin
  ~/.local/bin
  ~/.local/sbin
  "$DOTFILES"/bin
)

export PATH
for p in "${paths[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths
