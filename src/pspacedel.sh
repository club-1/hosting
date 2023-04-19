#!/bin/bash
DIR="${BASH_SOURCE%/*}"
. "$DIR/../lib/club1/functions.sh"

usage() {
	echo "Usage:"
	echo "  pspacedel [options] <login>"
	echo ""
	echo "Options:"
	echo "  -h    Show help."
	echo "  -r    Keep home directory"
	echo "  -m    Keep MariaDb MySql account."
	echo "  -f    Keep FPM pool"
	echo "  -g    Keep group."
	echo "  -q    Quiet."
	exit 0
}

optstring="hrmgq"

tryRoot
parse $optstring $@
loginGet

verbose "userdel $login"
ldapdeleteuser $login

[[ -z ${options[r]} ]] && homeDel
[[ -z ${options[m]} ]] && sqlUserDel
[[ -z ${options[f]} ]] && phpfpmpoolDel
[[ -z ${options[g]} ]] && groupDel

exit 0
