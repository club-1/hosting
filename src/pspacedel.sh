#!/bin/bash
DIR="${BASH_SOURCE%/*}"
. "$DIR/../lib/club1/functions.sh"

usage() {
	echo "Usage:"
	echo "  pspacedel [options] <login>"
	echo ""
	echo "Options:"
	echo "  -h    Show help."
	echo "  -g    Keep group."
	echo "  -r    Keep home directory."
	echo "  -m    Keep MariaDb MySql account."
	echo "  -f    Keep FPM pool."
	echo "  -q    Quiet."
	exit 0
}

optstring="hrmgq"

tryRoot
parse $optstring $@
loginGet

verbose "userdel $login"
ldapdeleteuser $login
removeFromAllGroups

[[ -z ${options[g]} ]] && groupDel
[[ -z ${options[r]} ]] && homeDel
[[ -z ${options[m]} ]] && sqlUserDel
[[ -z ${options[f]} ]] && phpfpmpoolDel

exit 0
