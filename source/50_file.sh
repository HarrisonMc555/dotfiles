# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Always use color output for `ls`
if is_osx; then
  alias ls="command ls -G"
  alias la='ls -a'
else
  alias ls="command ls --color -v"
  alias la='ls -A'
  alias l='ls -CF'
  export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
fi

alias ll='ls -al'
alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
# Directory listing
# if [[ "$(type -P tree)" ]]; then
#   alias ll='tree --dirsfirst -aLpughDFiC 1'
#   alias lsd='ll -d'
# else
#   alias ll='ls -al'
#   alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
# fi

# For typos
alias sl='ls'

# Easier navigation: .., ..., -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'
alias ~=cd

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

# Recursively delete `.DS_Store` files
function dsstore() {
    dirs="$@"
    if [[ ! "$1" ]]; then
        dirs=( . )
    fi
    find_no_err "${dirs[@]}" -name '*.DS_Store' -type f -ls -delete
}

# Recursively delete `*~` files
function tilde() {
    dirs=( "$@" )
    if [[ ! "$1" ]]; then
        dirs=( . )
    fi
    find_no_err "${dirs[@]}" -name '*~' -type f -ls -delete
}

function find_no_err() {
    find "$@" 2> >(grep -v -E \
                        -e '^find: .*: Permission denied$' \
                        -e '^find: .*: Operation not permitted$')
}

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"
alias eachfile=". eachfile"
alias forever=". forever"

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# Fast directory switching
mkdir -p "$DOTFILES"/caches/z
_Z_NO_PROMPT_COMMAND=1
_Z_DATA="$DOTFILES"/caches/z/z
. "$DOTFILES"/vendor/z/z.sh

function findnewer() {
    if [[ $# != 1 ]] && [[ $# != 2 ]]; then
        echo "Usage: findnewer val[ymwdHMS] [dir]"
        echo "  Ex: findnewer 1d"
        return 1
    fi
    valstring="$1"
    if [[ "$2" ]]; then
        dir="$2"
    else
        dir=.
    fi
    find "$dir" \
         -newermt "$(date -v -"$valstring" "+%Y-%m-%d %H:%M:%S")" \
         -type f \
         -print
}

alias wdiff="git diff --no-index --word-diff"
is_osx && alias ls='gls -v --color=auto'

function maxlinelength() {
    awk '{print length}' "$@" | sort -nr | head -1
}

function editbin() {
    local bin_name="$1"
    shift

    if [[ ! "$bin_name" ]]; then
        echo "Usage: editbin <binary>"
        return 1
    fi

    if [[ $(type -t "$bin_name") != file ]]; then
        echo "Argument must be a file"
        msg="$(type -f "$bin_name" 2>&1)"
        echo "(it was a ${msg})"
        return 1
    fi

    bin_location="$(which "$bin_name")"

    if [[ ! -r "$bin_location" ]]; then
        echo "Argument must be a readable file"
        return 1
    fi

    local editor
    if [[ "$VISUAL" ]]; then
        editor="$VISUAL"
    elif [[ "$EDITOR" ]]; then
        editor="$EDITOR"
    else
        editor=vi
    fi

    $editor "$bin_location" $@
}

alias gdn='git diff --no-index'

function lines() {
    wc -l "$@" | awk '{print $1}'
}

function words() {
    wc -w "$@" | awk '{print $1}'
}

function diff-percentage() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: diff-percentage FILE1 FILE2"
        return 1
    fi

    if [[ ! -f "$1" ]] || [[ ! -r "$1" ]] || \
           [[ ! -f "$2" ]] || [[ ! -r "$2" ]]; then
        echo "Both arguments must be readable files"
        return 1
    fi

    num_diff_lines=$(num-diff-lines "$1" "$2")
    file1_lines=$(lines "$1")
    file2_lines=$(lines "$2")
    max_lines="$file1_lines"
    if [[ "$file2_lines" -gt "$max_lines" ]]; then
        max_lines="$file2_lines"
    fi
    math="100 * ${num_diff_lines} / ${max_lines}"
    ratio=$(round "$math" 1)
    # ratio=$(echo "scale=1; 100 * ${num_diff_lines} / ${max_lines}" | bc)

    echo "diff-percentage for $1 and $2:"
    echo "${ratio}% different"
    echo "${num_diff_lines} / ${max_lines} lines are different"
}

function diffp() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: diff-percentage FILE1 FILE2"
        return 1
    fi

    if [[ ! -f "$1" ]] || [[ ! -r "$1" ]] || \
           [[ ! -f "$2" ]] || [[ ! -r "$2" ]]; then
        echo "Both arguments must be readable files"
        return 1
    fi

    num_diff_lines=$(num-diff-lines "$1" "$2")
    file1_lines=$(lines "$1")
    file2_lines=$(lines "$2")
    max_lines="$file1_lines"
    if [[ "$file2_lines" -gt "$max_lines" ]]; then
        max_lines="$file2_lines"
    fi
    math="100 * ${num_diff_lines} / ${max_lines}"
    ratio=$(round "$math" 0)

    echo "$ratio"
}

function round() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: round (VALUE|MATH) SCALE"
        return 1
    fi

    scale="$2"
    value=$(echo "scale=$((scale + 1)); $1" | bc)
    result=$(echo "scale=${scale}; "\
                  "(((10^${scale})*${value})+0.5)/(10^${scale})" | bc)
    echo $(printf "%.${scale}f" "$result")
}

function num-diff-lines() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: num-diff-lines FILE1 FILE2"
        return 1
    fi

    # The diff command lists the file names as the first two lines and the
    # region line numbers with @ symbols
    diff -U0 "$1" "$2" | tail -n+3 | grep -cv '^@'
}

function ediff() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: ediff FILE1 FILE2"
    fi
    emacsclient -e "(ediff \"$1\" \"$2\")" &&
        open -a Emacs
}
