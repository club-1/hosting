#!/bin/bash

if [ -z "$CERTBOT_DOMAIN" ] || [ -z "$CERTBOT_VALIDATION" ]
then
	echo "EMPTY DOMAIN OR VALIDATION"
	exit -1
fi

# Split domain into parts.
IFS='.' read -r -a parts <<< "$CERTBOT_DOMAIN"

TLD=${parts[-1]}
SLD=${parts[-2]}
DOMAIN="$SLD.$TLD"

HOST="_acme-challenge"

# If CERTBOT_DOMAIN is a subdomain.
if [ $CERTBOT_DOMAIN != $DOMAIN ]
then
	SUB=${CERTBOT_DOMAIN%.$DOMAIN}
	HOST="$HOST.$SUB"
fi

ZONE="/etc/bind/db.$DOMAIN"

printf "$HOST\t1\tIN\tTXT\t$CERTBOT_VALIDATION\n" >> $ZONE
dns-bump $ZONE

if [[ $CERTBOT_REMAINING_CHALLENGES == 0 ]]
then
	systemctl reload named
	sleep 300
fi
