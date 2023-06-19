#!/bin/bash
DIR="${BASH_SOURCE%/*}"
. "$DIR/../lib/club1/functions.sh"

set -x

new_ipv6=$1
new_ipv6_esc=${new_ipv6//./\\.}

ipv6_esc=${ipv6//./\\.}

usage()
{
	echo 'update-ipv6 <new IPv6>'
}

if [ -z $new_ipv6 ]; then
	usage
	exit 1
fi

bind_files=$(grep "$ipv6_esc" /etc/bind -r --files-with-matches)
all_etc_files=$(grep "$ipv6_esc" /etc -r --files-with-matches)

for f in $all_etc_files
do
	sed $f -e "s/$ipv6_esc/$new_ipv6/g" --in-place
done

for f in $bind_files
do
	dns-bump $f
done

systemctl reload named
