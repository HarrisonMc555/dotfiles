is_available z || return 1

# Fast directory switching
mkdir -p "$DOTFILES"/caches/z
_Z_NO_PROMPT_COMMAND=1
_Z_DATA="$DOTFILES"/caches/z/z
. "$DOTFILES"/vendor/z/z.sh
