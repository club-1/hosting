#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/functions.sh"

tryRoot

a2dissite "$redirect_vhost-le-ssl"
certbot $*
a2ensite "$redirect_vhost-le-ssl"
systemctl reload apache2

exit 0
