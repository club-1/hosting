#!/bin/bash

if [ -z "$CERTBOT_DOMAIN" ] || [ -z "$CERTBOT_VALIDATION" ]
then
	echo "EMPTY DOMAIN OR VALIDATION"
	exit -1
fi

HOST="_acme-challenge"
ZONE="/etc/bind/db.$CERTBOT_DOMAIN"
DATE=$(date +%Y%m%d%H)


if [[ $CERTBOT_REMAINING_CHALLENGES == 0 ]]
then
	sed $ZONE -Ei -e "/^$HOST.*$VALIDATION/d"
	dns-bump $ZONE
	rndc reload
	systemctl restart bind9
fi

printf "Result for $CERTBOT_DOMAIN\n
validation:	$CERTBOT_VALIDATION
remaining:	$CERTBOT_REMAINING_CHALLENGES
output:
$CERTBOT_AUTH_OUTPUT
" | mailx -s "Certbot renewal result for $CERTBOT_DOMAIN" root
