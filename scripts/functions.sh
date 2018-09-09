#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/config.sh"

declare -A options=()
declare params=()
declare login=''

parse() {
	local optstring=$1
	shift
	[ $# = 0 ] && usage # if no params, show usage

	while [ $# -gt 0 ]; do
		optsGet $optstring $@
		shift $lastopt
		params+=($1)
		shift
	done
}

optsGet() {
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

verbose() {
	[[ -n ${options[v]} ]] && echo $*
}

loginGet() {
	[ -z ${params[0]} ] && usage # if only options, show usage
	login=${params[0]}
}

loginUpdate() {
	local loginnew=$1
	homeUpdate $loginnew
	groupUpdate $loginnew
	sqlUserUpdate $loginnew
	verbose "update UNIX user '$login' into '$loginnew'"
	sudo usermod -l $loginnew $login
}

homeDel() {
	verbose "delete '$login' home directory"
	sudo rm -f "/home/$login"
}

homeUpdate() {
	local loginnew=$1
	verbose "update '/home/$login' into '/home/$loginnew'"
	sudo mv "/home/$login" "/home/$loginnew"
}

groupDel() {
	verbose "delete group '$login'"
	sudo groupdel $login
}

groupUpdate() {
	local loginnew=$1
	verbose "update group '$login' into '$loginnew'"
	sudo groupmod -n $loginnew $login
}

passwordSet() {
	local login=$1
	if [ $# -gt 1 ]; then
		password=$2
		verbose "set password: $password"
		echo "$login:$password" | sudo chpasswd
	else
		verbose "set password"
		sudo passwd $login
	fi
}

shellAdd() {
	verbose 'add shell'
	usermod -s /bin/bash $login
}

shellDel() {
	verbose 'delete shell'
	usermod -s /bin/false $login
}

sqlUserAdd() {
	verbose "create MySql user '$login@localhost' identified via PAM and grant privileges"
	sudo mysql -u root -e "CREATE USER $login@localhost IDENTIFIED VIA pam; GRANT ALL PRIVILEGES ON \`$login\_%\` . * TO '$login'@'localhost';"
}

sqlUserDel() {
	verbose "delete MySql user '$login@localhost'"
	sudo mysql -u root -e "DROP USER IF EXISTS $login@localhost"
}

sqlUserUpdate() {
	local loginnew=$1
	nbuser=$(sudo mysql -u root -e 'select user from mysql.user' | grep -sw $login | wc -l)
}

subdomainAdd() {
	if [ -n $1 ]; then
		local subdomain=$1
		verbose "create subdomain $subdomain.$sld.$tld"
		curl -XPOST -d "hostname1=$subdomain.$sld.$tld&address1=$ip&type1=A&sld=$sld&tld=$tld&api_key=$api_key&api_user=$api_user' 'https://api.planethoster.net/reseller-api/save-ph-dns-records"
	fi
}

vhostAdd() {
	verbose "create virtualhost"
}

vhostDel() {
	verbose "delete virtualhost"
}
