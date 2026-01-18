#!/bin/bash
# send a Matrix invitation token by email
# email can be provided as first argument, otherwise, it will be asked interactively

set -e

# print usage and exit
usage () {
    cat <<'EOF'
Send a Matrix invitation token by email.

Usage: matrixinvite [EMAIL_ADDRESS]

Email address can be provided as first argument,
otherwise, it will be asked interactively.
  
  --help, -h		print this help

Source code: <https://github.com/club-1/hosting/blob/master/src/matrixinvite.sh>
Club1 doc: <https://club1.fr/docs/fr/services/matrix.html#commande-matrixinvite>
EOF
	exit 0
}



if test -z "$1"
then
	echo 'mail address ?'
	read mailAddr
else
	if [ "$1" = '--help' ] || [ "$1" = '-h' ]
	then
		usage
	else
		mailAddr="$1"
	fi
fi

jsonToken=$(matrixtoken -j)

expire=$(echo "$jsonToken" | jq '.expiry_time // ""' --raw-output)
token=$(echo "$jsonToken" | jq '.token // ""' --raw-output)

# used for testing
# token='testT0k3n'
# expire='1625394937000'


expireMsg='';

if test -n expire
then
	expire="${expire%???}"
	expireDate="$(LC_TIME='fr_FR.utf8' date -d @${expire} +'%A %-d %B %Y à %R')"
	expireMsg="Ce jeton expirera le ${expireDate}"
fi


mutt -s 'Invitation Matrix sur le serveur club1.fr' -- "$mailAddr" \
<<EOF
Voici un code d'invitation pour le serveur Matrix de club1.
Il te permet de te créer un compte en allant sur <https://riot.club1.fr/#/register>.

Jeton à copier :

${token}

${expireMsg}

Plus d'information sur le serveur Matrix de club1 :
<https://club1.fr/matrix>
EOF

echo "invitation sent to ${mailAddr} with token '${token}'"

