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
ZONE="/etc/bind/db.$DOMAIN"

# Strip validation record for this challenge.
sed $ZONE -Ei -e "/^$HOST.*$CERTBOT_VALIDATION/d"
dns-bump $ZONE

# If it is the last, reload bind and send mail.
if [[ $CERTBOT_REMAINING_CHALLENGES == 0 ]]
then
	rndc reload
	systemctl restart bind9
	printf "Result for $CERTBOT_DOMAIN:\n$CERTBOT_AUTH_OUTPUT" | mailx -s "Certbot renewal result for $CERTBOT_DOMAIN" root
fi
