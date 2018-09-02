#!/bin/bash

declare -A options=()

optionsGet() {
	local optstring=$1
	shift
	while getopts ":$optstring" opt; do
		case $opt in
		h)
			usage
			;;
		:)
			echo "$OPTARG : requires an argument"
			exit 1
			;;
		\?)
			echo "$OPTARG : invalid option"
			exit 1
			;;
		*)
			[ -z $OPTARG ] && options[$opt]=1 || options[$opt]=$OPTARG
			;;
		esac
	done
	lastopt=$((OPTIND - 1))
	OPTIND=1
}
