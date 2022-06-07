# OSX-only stuff. Abort if not OSX.
is_osx || return 1

if [[ ! -f ~/.iterm2_shell_integration.bash ]]; then
    curl -L https://iterm2.com/shell_integration/install_shell_integration.sh |
        bash
fi
