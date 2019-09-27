is_available shellcheck || return 1

export SHELLCHECK_OPTS="-e SC1090"

