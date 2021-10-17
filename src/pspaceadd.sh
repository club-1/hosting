#!/bin/bash
DIR="${BASH_SOURCE%/*}"
. "$DIR/../lib/club1/functions.sh"

usage() {
	echo "Usage:"
	echo "  pspaceadd [options] <login>"
	echo ""
	echo "Options:"
	echo "  -h    Show help."
	echo "  -s    With shell."
	echo "  -m    With MariaDb MySql account."
	echo "  -q    Quiet."
	exit 0
}

optstring="hsmq"

tryRoot
parse $optstring $@
loginGet

verbose "create user $login"
nextuid=$(ldapnextuid)
ldapaddgroup $login $nextuid
ldapadduser $login $login $nextuid

[[ -n ${options[s]} ]] && shellAdd
[[ -n ${options[m]} ]] && sqlUserAdd

exit 0
