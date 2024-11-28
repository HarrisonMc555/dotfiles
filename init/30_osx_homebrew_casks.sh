# -*- mode: shell-script; sh-shell: bash -*-

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

# Ensure the cask kegs are installed.
kegs=(
  homebrew/cask
  homebrew/cask-drivers
  homebrew/cask-fonts
)
brew_tap_kegs

# Hack to show the first-run brew-cask password prompt immediately.
brew info --cask this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  alfred # Can automate, mostly unused, kind of used for better application search than command-space
  amazon-music # Music
  background-music # Change volume for each app individually
  balenaetcher # Flash OS ISO images onto USB drive to boot into, e.g. Linux
  caffeine # Keep computer awake
  captin # Display when caps lock is turned on/off
  emacs # Text editor
  emacsclient # Launch text editor
  fastscripts # Run script on keyboard shortcut, used for switching apps quickly (much faster than Automator)
  firefox # Web browser
  font-hack-nerd-font # Mostly unused, provides fun icons for terminal
  gimp # Image editor, kind of like free version of Photoshop
  google-chrome # Web browser
  hex-fiend # Hex file viewer
  istat-menus # Display memory and CPU usage in menu, mostly unused
  iterm2 # Terminal emulator
  jumpcut # Clipboard history
  karabiner-elements # Customize keyboard, e.g. use Caps lock as "Super" key
  meld # Diff merger
  mutespotifyads # Mute ads on Spotify app
  screen # Create, pause, and resume terminal sessions
  spotify # Music
  steam # Games
  vanilla # Hide menu bar icons
  visual-studio-code # Code editor, relatively lightweight IDE

  ## These were installed by me but I'm not sure if I want them every time
  sourcetree # Atlassian Git client
  accessmenubarapps # Shows menu bar applications, helpful when applications have lots of menus
  caffeine # Keep computer awake
  grandperspective # Storage space visualizer
  jetbrains-toolbox # Tool for managing JetBrains tool installations
  krita # pixel editor
  microsoft-remote-desktop # Connect to remote Windows computers
  onedrive # Cloud storage
  spaceradar # Storage space visualizer
  thonny # Python GUI
  webex # WebEx video call application
  nowplaying-cli # Use internal API to query "Now Playing" information

  ## These were installed by "Cowboy" Ben Alman
  # a-better-finder-rename
  # alfred
  # android-platform-tools
  # bartender
  # battle-net
  # bettertouchtool
  # charles
  # chromium
  # chronosync
  # controllermate
  # docker
  # dropbox
  # gyazo
  # macvim
  # messenger-for-desktop
  # midi-monitor
  # moom
  # omnidisksweeper
  # race-for-the-galaxy
  # reaper
  # robo-3t
  # screenhero
  # scroll-reverser
  # skype
  # slack
  # sourcetree
  # steam
  # the-unarchiver
  # totalfinder
  # tower
  # vagrant
  # virtualbox
  # vlc
  # ynab
)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew list --cask 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew install --cask $cask
  done
  brew cleanup
fi

# Work around colorPicker symlink issue.
# https://github.com/caskroom/homebrew-cask/issues/7004
cps=()
for f in ~/Library/ColorPickers/*.colorPicker; do
  [[ -L "$f" ]] && cps=("${cps[@]}" "$f")
done

if (( ${#cps[@]} > 0 )); then
  e_header "Fixing colorPicker symlinks"
  for f in "${cps[@]}"; do
    target="$(readlink "$f")"
    e_arrow "$(basename "$f")"
    rm "$f"
    cp -R "$target" ~/Library/ColorPickers/
  done
fi
