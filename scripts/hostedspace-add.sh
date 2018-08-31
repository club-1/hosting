#!/bin/bash

usage() {
	echo "Usage:"
	echo "  hostedspace-add [options] NAME"
	echo ""
	echo "Options:"
	echo "  -h               Show help."
	echo "  -s               With shell."
	echo "  -p <password>    Set the password."
	exit 0
}

getOptions() {
	while getopts "hsp:" opt; do
		case $opt in
		h)
			usage
			;;
		s)
			options[0]='-s /bin/bash'
			;;
		p)
			options[1]="-p $OPTARG"
			;;
		esac
	done
	lastopt=$((OPTIND - 1))
	OPTIND=1
}

params=()
options=(
	'-s /bin/false'
)

if [ $# = 0 ]; then
	usage
fi

while [ $# -gt 0 ]; do
	getOptions $@
	shift $lastopt
	params+=($1)
	shift
done

if [ -z ${params[0]} ]; then
	usage
fi

useradd ${options[*]} ${params[0]}
exit 0
