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
dns-bump $ZONE

if [[ $CERTBOT_REMAINING_CHALLENGES == 0 ]]
then
	rndc reload
	systemctl restart bind9
	sleep 300
fi
