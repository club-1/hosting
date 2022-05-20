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
	echo "  -f    With FPM pool."
	echo "  -q    Quiet."
	exit 0
}

optstring="hsmfq"

tryRoot
parse $optstring $@
loginGet

verbose "create user $login"
nextuid=$(ldapnextuid)
ldapaddgroup $login $nextuid
ldapadduser $login $login $nextuid
mkhomedir_helper $login
chgrp home /home/$login
chmod 750 /home/$login

[[ -n ${options[s]} ]] && shellAdd
[[ -n ${options[m]} ]] && sqlUserAdd
[[ -n ${options[f]} ]] && phpfpmpoolAdd

exit 0
