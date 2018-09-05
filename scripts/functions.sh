#!/bin/bash
DIR=$(dirname "$0")
. "$DIR/config.sh"

declare -A options=()
declare params=()
declare login=''

parse() {
	local optstring=$1
	shift
	[ $# = 0 ] && usage # if no params, show usage

	while [ $# -gt 0 ]; do
		optionsGet $optstring $@
		shift $lastopt
		params+=($1)
		shift
	done
}

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

passwordSet() {
	login=$1
	if [ $# -gt 1 ]; then
		password=$2
		echo "$login:$password" | sudo chpasswd
	else
		sudo passwd $login
	fi
}

sqlUserAdd() {
	[[ -n ${options[v]} ]] && echo "create MySql user $login@localhost identified via PAM"
	sudo mysql -u root -e "CREATE USER $login@localhost IDENTIFIED VIA pam"
}

sqlUserDel() {
	[[ -n ${options[v]} ]] && echo "delete MySql user $login@localhost"
	sudo mysql -u root -e "DROP USER IF EXISTS $login@localhost"
}

subdomainAdd() {
	if [ -n $1 ]; then
		subdomain=$1
		curl -XPOST -d "hostname1=$subdomain.$sld.$tld&address1=$ip&type1=A&sld=$sld&tld=$tld&api_key=$api_key&api_user=$api_user' 'https://api.planethoster.net/reseller-api/save-ph-dns-records"
	fi
}

subdomainDel() {
	if [ -n $1 ]; then
		subdomain=$1
		curl -XPOST -d "sld=$subdomain.$sld&tld=$tld&api_key=$api_key&api_user=$api_user' 'https://api.planethoster.net/reseller-api/delete-ph-dns-area"
	fi
}
