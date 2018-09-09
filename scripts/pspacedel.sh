#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/functions.sh"

usage() {
	echo "Usage:"
	echo "  hostedspace-del [options] <login>"
	echo ""
	echo "Options:"
	echo "  -h               Show help."
	echo "  -v               Verbose."
	echo "  -r               Remove home directory"
	echo "  -m               Remove MariaDb MySql account."
	echo "  -g               Keep group."
	exit 0
}

optstring="hvrmg"

parse $optstring $@
loginGet

verbose "userdel $login"
sudo userdel $login

[[ -n ${options[r]} ]] && homeDel
[[ -n ${options[m]} ]] && sqlUserDel
[[ -z ${options[g]} ]] && groupDel

exit 0
