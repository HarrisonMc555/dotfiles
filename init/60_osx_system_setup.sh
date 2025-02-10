# -*- sh-shell: bash -*-

# Allow ssh access to this computer
sudo systemsetup -setremotelogin on

# Increase the maximum number of open files
sudo launchctl limit maxfiles 64000 6400
