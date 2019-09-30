#!/bin/bash
# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Homebrew recipes
recipes=(
  bash
  bash-completion@2
  bat
  colordiff
  coreutils
  dos2unix
  fd
  fzf
  git
  go
  grip
  ipython
  ispell
  lynx
  node
  openssh
  pandoc
  pygments
  ripgrep
  shellcheck
  ssh-copy-id
  sshrc
  trash
  tree
  wget
  # ansible
  # awscli
  # cmatrix
  # cowsay
  # git-extras
  # htop-osx
  # hub
  # id3tool
  # jq
  # lesspipe
  # man2html
  # mercurial
  # nmap
  # postgresql
  # reattach-to-user-namespace
  # sl
  # terminal-notifier
  # the_silver_searcher
  # tmux
  # tmux-xpanes
)

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# bash
if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
  e_header "Adding $binroot/bash to the list of acceptable shells"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
  e_header "Making $binroot/bash your default shell"
  sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
  e_arrow "Please exit and restart all your shells."
fi

# Go development
go get -u golang.org/x/lint/golint
