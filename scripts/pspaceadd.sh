#!/bin/bash
DIR=$(dirname "$0")
. "$DIR/functions.sh"

usage() {
	echo "Usage:"
	echo "  hostedspace-add [options] <login>"
	echo ""
	echo "Options:"
	echo "  -h               Show help."
	echo "  -v               Verbose."
	echo "  -s               With shell."
	echo "  -m               With MariaDb MySql account."
	exit 0
}

optstring="hvsm"
useradd_options=(
	'-s /bin/false' # without shell
	'-m' # with home directory
	'-U' # with user default group
)

parse $optstring $@
loginGet

if [[ -n ${options[s]} ]]; then
	verbose 'option with shell'
	useradd_options[0]='-s /bin/bash'
fi

useradd_options+=('')
verbose "useradd ${useradd_options[*]}$login"
sudo useradd ${useradd_options[*]}$login
passwordSet $login

if [[ -n ${options[m]} ]]; then
	sqlUserAdd
fi

exit 0
