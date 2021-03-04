#!/bin/bash

domain=$1
user=$2
php72dir='/etc/php/7.2/fpm/pool.d'
php74dir='/etc/php/7.4/fpm/pool.d'
apachedir='/etc/apache2/sites-available'
vhostfile="$apachedir/$domain-le-ssl.conf"
php72file="$php72dir/$domain.conf"
php74file="$php74dir/$user.conf"

usage()
{
	echo 'updatephp <domain> <user>'
}

if [ -z $domain ] || [ -z $user ]; then
	usage
	exit 1
fi
if [ ! -e $php72file ]; then
	echo no such fpm pool: $php72file
	exit 2
fi
if [ ! -e $vhostfile ]; then
	echo no such apache vhost: $vhostfile
	exit 3
fi
if [ -f $php74file ]; then
	echo $php74file already exists, skipping creation
else
	cp $php72file $php74file
	dos2unix $php74file
	echo >> $php74file # add newline
	sed -i $php74file \
		-e "s/$domain/$user/" \
		-e "s/php7.2-fpm/php-fpm/"
fi

sed -i $vhostfile -e "s/php7.2-fpm.$domain/php-fpm.$user/"

rm $php72file

systemctl reload php7.2-fpm php7.4-fpm apache2
