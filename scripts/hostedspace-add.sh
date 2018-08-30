#!/bin/bash

usage() {
	echo "Usage:"
	echo "  hostedspace-add [name] [options]"
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
			echo "With shell."
			;;
		p)
			echo "Set the password: $OPTARG"
			;;
		esac
	done
	lastopt=$((OPTIND - 1))
	OPTIND=1
}

params=()

if [ $# = 0 ]; then
	usage
else
	while [ $# -gt 0 ]; do
		getOptions $@
		shift $lastopt
		params+=($1)
		shift
	done
	echo ${params[*]}
	#useradd $username
fi
