paths_rev=(
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

paths=()

for p in "${paths_rev[@]}"; do
  paths=("$p" "${paths[@]}")
done

export PATH
for p in "${paths[@]}"; do
  [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
done
unset p paths paths_rev
