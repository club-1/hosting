#!/bin/bash
DIR=$(dirname "$0")
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
userdel_options=()

parse $optstring $@
loginGet

if [[ -n ${options[r]} ]]; then
	verbose 'option remove home directory'
	userdel_options+=('-r')
fi

userdel_options+=('')
verbose "userdel ${userdel_options[*]}$login"
sudo userdel ${userdel_options[*]}$login

if [[ -z ${options[g]} ]]; then
	verbose "delete group '$login'"
	sudo groupdel $login
fi
if [[ -n ${options[m]} ]]; then
	sqlUserDel
fi

exit 0
