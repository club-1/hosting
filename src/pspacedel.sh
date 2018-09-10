#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/functions.sh"

usage() {
	echo "Usage:"
	echo "  $0 [options] <login>"
	echo ""
	echo "Options:"
	echo "  -h    Show help."
	echo "  -r    Remove home directory"
	echo "  -m    Remove MariaDb MySql account."
	echo "  -g    Keep group."
	echo "  -q    Quiet."
	exit 0
}

optstring="hrmgq"

tryRoot
parse $optstring $@
loginGet

verbose "userdel $login"
userdel $login

[[ -n ${options[r]} ]] && homeDel
[[ -n ${options[m]} ]] && sqlUserDel
[[ -z ${options[g]} ]] && groupDel

exit 0
