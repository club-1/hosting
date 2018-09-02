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

params=()
optstring="hvsmp:"
login=''
useradd_options=(
	'-s /bin/false'
)

optionsExecute() {
	if [[ -n ${options[s]} ]]; then
		[[ -n ${options[v]} ]] && echo 'with shell'
		useradd_options[0]='-s /bin/bash'
	fi
	if [[ -n ${options[m]} ]]; then
		[[ -n ${options[v]} ]] && echo 'with mysql'
		mysql -u root -e "CREATE USER $login@localhost IDENTIFIED VIA pam"
	fi
	if [[ -n ${options[p]} ]]; then
		[[ -n ${options[v]} ]] && echo "with password: ${options[p]}"
		useradd_options[1]="-p ${options[p]}"
	fi
}

[ $# = 0 ] && usage

while [ $# -gt 0 ]; do
	optionsGet $optstring $@
	shift $lastopt
	params+=($1)
	shift
done
[ -z ${params[0]} ] && usage

optionsExecute
login=${params[0]}
[[ -n ${options[v]} ]] && echo "useradd ${useradd_options[*]} $login"
useradd ${useradd_options[*]} $login

exit 0
