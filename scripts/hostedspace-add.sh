#!/bin/bash

usage() {
	echo "Usage:"
	echo "  hostedspace-add [options] NAME"
	echo ""
	echo "Options:"
	echo "  -h               Show help."
	echo "  -s               With shell."
	echo "  -m               With MariaDb MySql account."
	echo "  -p <password>    Set the password."
	exit 0
}

getOptions() {
	while getopts "hsmp:" opt; do
		case $opt in
		h)
			usage
			;;
		s)
			useradd_options[0]='-s /bin/bash'
			;;
		m)
			mysql=1
			;;
		p)
			useradd_options[1]="-p $OPTARG"
			;;
		esac
	done
	lastopt=$((OPTIND - 1))
	OPTIND=1
}

login=''
mysql=0
params=()
useradd_options=(
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
login=${options[*]}
useradd $login ${params[0]}

if [ $mysql = 1 ]; then
	mysql -u root -e "CREATE USER $login@localhost IDENTIFIED VIA pam"
fi
exit 0
