#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
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

parse $optstring $@
loginGet

verbose "useradd -mUs /bin/false $login"
sudo useradd -mUs /bin/false $login # with home directory, default group and without shell
passwordSet $login

[[ -n ${options[s]} ]] && shellAdd
[[ -n ${options[m]} ]] && sqlUserAdd

exit 0
