#!/bin/bash
DIR=$(dirname "$0")
. "$DIR/functions.sh"

usage() {
	echo "Usage:"
	echo "  hostedspace-add [options] NAME"
	echo ""
	echo "Options:"
	echo "  -h               Show help."
	echo "  -v               Verbose."
	echo "  -s               With shell."
	echo "  -m               With MariaDb MySql account."
	echo "  -p <password>    Set the password."
	exit 0
}

optstring="hvsmp:"
useradd_options=(
	'-s /bin/false' # without shell
	'-m' # with home directory
	'-U' # with user default group
)

parse $optstring $@
[ -z ${params[0]} ] && usage # if only options, show usage
login=${params[0]}

if [[ -n ${options[s]} ]]; then
	[[ -n ${options[v]} ]] && echo 'option with shell'
	useradd_options[0]='-s /bin/bash'
fi

useradd_options+=('')
[[ -n ${options[v]} ]] && echo "useradd ${useradd_options[*]}$login"
sudo useradd ${useradd_options[*]}$login

if [[ -n ${options[p]} ]]; then
	[[ -n ${options[v]} ]] && echo "option with password: ${options[p]}"
	passwordSet $login ${options[p]}
else
	passwordSet $login
fi
if [[ -n ${options[m]} ]]; then
	sqlUserAdd
fi

exit 0
