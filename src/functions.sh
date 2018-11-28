#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/config.sh"

declare -A options=()
declare params=()
declare login=''

tryRoot() {
	[ "$USER" != 'root' ] && echo 'ERROR: This script must be run as root' >&2 && usage
}

confirm() {
	echo $*
	read -p "continue (y/N)?" choice
	case "$choice" in
	y | Y) echo "yes" ;;
	*) exit 1 ;;
	esac
}

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
	[[ -n ${options[v]} || -z ${options[q]} ]] && echo $*
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
	usermod -l $loginnew $login
}

homeDel() {
	verbose "delete '$login' home directory"
	rm -f "/home/$login"
}

homeUpdate() {
	local loginnew=$1
	verbose "update '/home/$login' into '/home/$loginnew'"
	mv "/home/$login" "/home/$loginnew"
}

groupDel() {
	verbose "delete group '$login'"
	groupdel $login
}

groupUpdate() {
	local loginnew=$1
	verbose "update group '$login' into '$loginnew'"
	groupmod -n $loginnew $login
}

passwordSet() {
	local login=$1
	if [ $# -gt 1 ]; then
		password=$2
		verbose "set password of '$login': $password"
		echo "$login:$password" | chpasswd
	else
		verbose "set password of '$login'"
		passwd $login
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
	mysql -u root -e "
		CREATE USER $login@localhost IDENTIFIED VIA pam;
		GRANT ALL PRIVILEGES ON \`$login\_%\` . * TO '$login'@'localhost';
		INSERT INTO phpmyadmin.pma__users (username, usergroup) VALUES ('$login', '$pma_usergroup');"
}

sqlUserDel() {
	verbose "delete MySql user '$login@localhost'"
	mysql -u root -e "
		DROP USER IF EXISTS $login@localhost;
		DELETE FROM phpmyadmin.pma__users WHERE username = '$login';"
}

sqlUserUpdate() {
	local loginnew=$1
	# nbuser=$(mysql -u root -e 'select user from mysql.user' | grep -sw $login | wc -l)
	mysql -u root -e "
		UPDATE mysql.user SET User = '$loginnew' WHERE Host = 'localhost' AND User = '$login';
		UPDATE phpmyadmin.pma__users SET username = '$loginnew' WHERE username = '$login';"
}

subdomainAdd() {
	if [ -n $1 ]; then
		local subdomain="$(cut -d : -f1 <<<$1)"
		local domain=$subdomain.$sld.$tld
		confirm "create subdomain '$domain'"
		curl -XPOST -d "hostname1=$subdomain&address1=$ip&type1=A&sld=$sld&tld=$tld&api_key=$api_key&api_user=$api_user" 'https://api.planethoster.net/reseller-api/save-ph-dns-records'
		vhostAdd $domain
	fi
}

subdomainDel() {
	if [ -n $1 ]; then
		local subdomain=$1
		vhostDel $1
	fi
}

vhostAdd() {
	if [ -n $1 ]; then
		local domain="$(cut -d : -f1 <<<$1)"
		local dir="$(cut -d : -f2 <<<$1)"
		local subdir="/home/$login/$dir"
		confirm "create virtualhost '$domain' on '$subdir'"
		sed -e "s#\${domain}#$domain#" -e "s#\${email}#$email#" -e "s#\${subdir}#$subdir#" "$DIR/../res/vhost-default.conf" >"/etc/apache2/sites-available/$domain.conf"
		verbose "create fpm pool for '$domain'"
		sed -e "s#\${domain}#$domain#" -e "s#\${user}#$login#" "$DIR/../res/fpm-pool.conf" >"/etc/php/$phpversion/fpm/pool.d/$domain.conf"
		systemctl restart "php$phpversion-fpm"
		a2ensite "$domain.conf"
		systemctl reload apache2
		certbot --apache -d $domain
	fi
}

vhostDel() {
	if [ -n $1 ]; then
		local domain="$(cut -d : -f1 <<<$1)"
		confirm "delete virtualhost '$domain'"
		a2dissite $domain
		rm "/etc/apache2/sites-available/$domain.conf"
		systemctl reload apache2
		verbose "delete fpm pool for '$domain'"
		rm "/etc/php/$phpversion/fpm/pool.d/$domain.conf"
		systemctl restart "php$phpversion-fpm"
	fi
}
