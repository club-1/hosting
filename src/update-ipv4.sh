#!/bin/bash
DIR="${BASH_SOURCE%/*}"
. "$DIR/../lib/club1/functions.sh"

set -x

new_ipv4=$1
new_ipv4_esc=${new_ipv4//./\\.}

ip_esc=${ip//./\\.}

usage()
{
	echo 'update-ipv4 <new IPv4>'
}

if [ -z $new_ipv4 ]; then
	usage
	exit 1
fi

bind_files=$(grep "$ip_esc" /etc/bind -r --files-with-matches)
all_etc_files=$(grep "$ip_esc" /etc -r --files-with-matches)

for f in $all_etc_files
do
	sed $f -e "s/$ip_esc/$new_ipv4/g" --in-place
done

for f in $bind_files
do
	dns-bump $f
done

systemctl reload named
