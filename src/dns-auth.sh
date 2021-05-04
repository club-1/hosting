#!/bin/bash

if [ -z "$CERTBOT_DOMAIN" ] || [ -z "$CERTBOT_VALIDATION" ]
then
	echo "EMPTY DOMAIN OR VALIDATION"
	exit -1
fi

HOST="_acme-challenge"
ZONE="/etc/bind/db.$CERTBOT_DOMAIN"
DATE=$(date +%Y%m%d%H)

printf "$HOST\t1\tIN\tTXT\t$CERTBOT_VALIDATION\n" >> $ZONE
perl -i -pe 'BEGIN {chomp ($now=qx/date +%Y%m%d/)};
/(\d{8})(\d{2})(\s+;\s+serial)/i and do {
	$serial = ($1 eq $now ? $2+1 : 0);
	s/\d{8}(\d{2})/sprintf "%8d%02d",$now,$serial/e;
}' $ZONE

if [[ $CERTBOT_REMAINING_CHALLENGES == 0 ]]
then
	rndc reload
	systemctl restart bind9
	sleep 300
fi
