#!/bin/bash
DIR=$(dirname "$0")
. "$DIR/functions.sh"

usage() {
	echo "Usage:"
	echo "  hostedspace-add <command> [options] <login>"
	echo ""
	echo "Commands:"
	echo "  add"
	echo "  update"
	echo "  delete"
	echo ""
	echo "Options:"
	echo "  -h               (aud) Show help."
	echo "  -v               (aud) Verbose."
	echo "  -s               (a-d) shell access."
	echo "  -m               (a-d) MariaDb MySql account."
	echo "  -p               (-u-) password."
	echo "  -P <password>    (-u-) password."
	echo "  -l <new_login>   (-u-) login."
	exit 0
}

optionsAdd() {
	if [[ -n ${options[m]} ]]; then
		sqlUserAdd
	fi
}

optionsUpdate() {
	if [[ -n ${options[p]} ]]; then
		verbose "option with password"
		passwordSet $login
	fi
	if [[ -n ${options[P]} ]]; then
		verbose "option with password: ${options[P]}"
		passwordSet $login ${options[P]}
	fi
}

optionsDelete() {
	if [[ -n ${options[m]} ]]; then
		sqlUserDel
	fi
}

command=$1
shift
case $command in
add)
	parse "hvsm" $@
	loginGet
	optionsAdd
	;;
update)
	parse "hvpP:n:" $@
	loginGet
	optionsUpdate
	;;
delete)
	parse "hvsm" $@
	loginGet
	optionsDelete
	;;
*)
	usage
	;;
esac

exit 0
