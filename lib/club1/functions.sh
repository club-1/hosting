#!/bin/bash
DIR="${BASH_SOURCE%/*}"

# Read common vars from config.env
# the incantation here ensures (by env) that only key=value pairs are present
# then declare-ing the result puts those vars in our environment
declare $(env -i `sed $DIR/../../etc/club1/config.env -e '/^#/d'`) > /dev/null
declare $(env -i `sed /etc/club1/config.env -e '/^#/d' 2> /dev/null`) > /dev/null
declare $(env -i `sed $HOME/.config/club1/config.env -e '/^#/d' 2> /dev/null`) > /dev/null

declare -A options=()
declare params=()
declare login=''

### Generic functions

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

### pspace functions

loginGet() {
	[ -z ${params[0]} ] && usage # if only options, show usage
	login=${params[0]}
}

loginUpdate() {
	local loginnew=$1
	homeUpdate $loginnew
	groupUpdate $loginnew
	sqlUserUpdate $loginnew
	verbose "updating UNIX user '$login' into '$loginnew'"
	ldaprenameuser $login $loginnew
	nscd --invalidate passwd
}

homeDel() {
	verbose "deleting '$login' home directory"
	rm -rf "/home/$login"
}

homeUpdate() {
	local loginnew=$1
	verbose "updating '/home/$login' into '/home/$loginnew'"
	mv "/home/$login" "/home/$loginnew"
	ldapmodifyuser $login <<< "changetype: modify
		replace: homeDirectory
		homeDirectory: /home/$loginnew" > /dev/null
	nscd --invalidate passwd
}

groupDel() {
	verbose "deleting group '$login'"
	ldapdeletegroup $login
	nscd --invalidate group
}

groupUpdate() {
	local loginnew=$1
	verbose "updating group '$login' into '$loginnew'"
	ldaprenamegroup $login $loginnew
	nscd --invalidate group
}

removeFromAllGroups() {
	grep ":.*$login" /etc/group | cut -d: -f1 | while read group
	do
		deluser "$login" "$group"
	done
}

passwordSet() {
	local login=$1
	if [ $# -gt 1 ]; then
		password=$2
		verbose "setting password of '$login': $password"
		echo "$login:$password" | chpasswd
	else
		verbose "setting password of '$login'"
		passwd $login
	fi
}

shellAdd() {
	verbose 'adding shell'
	ldapmodifyuser $login <<< "changetype: modify
		replace: loginShell
		loginShell: /bin/bash" > /dev/null
	nscd --invalidate passwd
}

shellDel() {
	verbose 'deleting shell'
	ldapmodifyuser $login <<< "changetype: modify
		replace: loginShell
		loginShell: /bin/false" > /dev/null
	nscd --invalidate passwd
}

sqlUserAdd() {
	verbose "creating MySql user '$login@localhost' identified via PAM and grant privileges"
	mysql -u root -e "
		CREATE USER \`$login\`@localhost IDENTIFIED VIA pam;
		GRANT ALL PRIVILEGES ON \`$login\_%\` . * TO \`$login\`@localhost;
		INSERT INTO phpmyadmin.pma__users (username, usergroup) VALUES ('$login', '$pma_usergroup');"
}

sqlUserDel() {
	verbose "deleting MySql user '$login@localhost'"
	mysql -u root -e "
		DROP USER IF EXISTS \`$login\`@localhost;
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
		local binddb="/etc/bind/db.$sld.$tld"
		confirm "create subdomain '$domain'"
		printf "$subdomain\tIN\tA\t$ip\t; $login\n" | expand -t 24,32,40,56 | unexpand -a >> $binddb
		dns-bump $binddb
		systemctl reload named
		vhostAdd "$domain:$(cut -d : -f2 <<<$1)"
	fi
}

subdomainDel() {
	if [ -n $1 ]; then
		local subdomain="$(cut -d : -f1 <<<$1)"
		local domain=$subdomain.$sld.$tld
		local binddb="/etc/bind/db.$sld.$tld"
		confirm "delete subdomain '$domain'"
		sed -ni "/^$subdomain	/!p" $binddb
		dns-bump $binddb
		systemctl reload named
		vhostDel "$domain:$(cut -d : -f2 <<<$1)"
	fi
}

phpfpmpoolAdd() {
	local file="/etc/php/$phpversion/fpm/pool.d/$login.conf"
	verbose "creating fpm pool for '$login'"
	if [ ! -f $file ]; then
		sed -e "s#\${user}#$login#" "$DIR/../../share/club1/fpm-pool.conf" > $file
	fi
	systemctl restart "php$phpversion-fpm"
}

phpfpmpoolDel() {
	verbose "deleting fpm pool for '$login'"
	rm "/etc/php/$phpversion/fpm/pool.d/$login.conf"
	systemctl restart "php$phpversion-fpm"
}

vhostAdd() {
	if [ -n $1 ]; then
		local domain="$(cut -d : -f1 <<<$1)"
		local level=$(domainLevel $domain)
		local top=$(getTopDomain $domain)
		local dir="$(cut -d : -f2 <<<$1)"
		local subdir="/home/$login/$dir"
		confirm "creating virtualhost '$domain' on '$subdir'"
		if [[ $level -lt 3 ]] && [ -d /etc/letsencrypt/live/$top ]; then
			echo using already existing certificates for parent domain $top
		else
			siteAdd "$domain"
		fi
		if [ -f $subdir ]; then
			verbose "'$subdir' is a file, making a backup"
			sudo -u $login mv $subdir $subdir.bak
		fi
		if [ ! -e $subdir ]; then
			verbose "'$subdir' does not exist, creating it"
			sudo -u $login mkdir -p $subdir
		fi
		sed -e "s#\${domain}#$domain#" -e "s#\${email}#$email#" -e "s#\${subdir}#$subdir#" -e "s#\${user}#$login#" "$DIR/../../share/club1/vhost-default.conf" >"/etc/apache2/sites-available/$domain.conf"
		a2ensite -q "$domain.conf"
		systemctl reload apache2
	fi
}

vhostDel() {
	if [ -n $1 ]; then
		local domain="$(cut -d : -f1 <<<$1)"
		local dir="$(cut -d : -f2 <<<$1)"
		confirm "delete virtualhost '$domain'"
		a2dissite $domain
		rm "/etc/apache2/sites-available/$domain.conf"
		rm "/home/$login/$dir/error.log"
		rm "/home/$login/$dir/access.log"
		systemctl reload apache2
		if [ -f "/etc/nginx/sites-available/$domain.conf" ]; then
			siteDel "$domain"
		fi
	fi
}

siteAdd() {
	if [ -n $1 ]; then
		local domain="$1"
		sleepProgress 60
		certbot certonly --non-interactive --nginx --key-type ecdsa -d "$domain"
		sed -e "s#\${domain}#$domain#" "$DIR/../../share/club1/nginx-site.conf" >"/etc/nginx/sites-available/$domain.conf"
		ln -s "/etc/nginx/sites-available/$domain.conf" "/etc/nginx/sites-enabled"
		systemctl reload nginx
	fi
}

siteDel() {
	if [ -n $1 ]; then
		local domain="$1"
		rm "/etc/nginx/sites-enabled/$domain.conf"
		rm "/etc/nginx/sites-available/$domain.conf"
		systemctl reload nginx
		certbot delete --non-interactive --cert-name "$1"
	fi
}

getTopDomain() {
	echo $1 | sed -nE 's/^.+\.(.+\..+)$/\1/p'
}

domainLevel() {
	local dots=${1//[^.]}
	echo ${#dots}
}

sleepProgress() {
	printf '_%.0s' $(seq $*)
	printf '\n'
	for i in $(seq $*); do
		sleep 1
		printf '.'
	done
	echo
}

### Other functions

getLatestGithubRelease() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

