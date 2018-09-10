#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/functions.sh"

usage() {
	echo "Usage:"
	echo "  pspacemod <command> [options] <login>"
	echo ""
	echo "Commands:"
	echo "  add"
	echo "  update"
	echo "  delete"
	echo ""
	echo "Options:"
	echo "  -h               (aud) Show help."
	echo "  -s               (a-d) shell access."
	echo "  -m               (a-d) MariaDb MySql account."
	echo "  -p               (-u-) password."
	echo "  -P <password>    (-u-) password."
	echo "  -l <new_login>   (-u-) login."
	echo "  -q               (aud) Quiet."
	exit 0
}

optionsAdd() {
	[[ -n ${options[s]} ]] && shellAdd
	[[ -n ${options[m]} ]] && sqlUserAdd
}

optionsUpdate() {
	[[ -n ${options[p]} ]] && passwordSet $login
	[[ -n ${options[P]} ]] && passwordSet $login ${options[P]}
	[[ -n ${options[l]} ]] && loginUpdate $login ${options[l]}
}

optionsDelete() {
	[[ -n ${options[s]} ]] && shellDel
	[[ -n ${options[m]} ]] && sqlUserDel
}

tryRoot
command=$1
shift
case $command in
add)
	parse "hsmq" $@
	loginGet
	optionsAdd
	;;
update)
	parse "hpP:n:q" $@
	loginGet
	optionsUpdate
	;;
delete)
	parse "hsmq" $@
	loginGet
	optionsDelete
	;;
*)
	usage
	;;
esac

exit 0
