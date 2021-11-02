#!/bin/bash

if [ -z "$CERTBOT_DOMAIN" ] || [ -z "$CERTBOT_VALIDATION" ]
then
	echo "EMPTY DOMAIN OR VALIDATION"
	exit -1
fi

HOST="_acme-challenge"
ZONE="/etc/bind/db.$CERTBOT_DOMAIN"
DATE=$(date +%Y%m%d%H)

sed $ZONE -Ei -e "/^$HOST.*$VALIDATION/d"

dns-bump $ZONE

if [[ $CERTBOT_REMAINING_CHALLENGES == 0 ]]
then
	rndc reload
	systemctl restart bind9
fi
