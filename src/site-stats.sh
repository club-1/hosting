#!/bin/sh -e

# default path inside users's static folder
default="site-stats"

usage () {
	 cat <<'EOF'
Export HTML statistics for a given domain name

Usage: DOMAIN [PATH]
  
  --help, -h		print this help

If no PATH is provided, it will use the default path:

	~/static/site-stats/

Output file name is: DOMAIN.html

Source code: <https://github.com/club-1/hosting/blob/master/src/site-stats.sh>
EOF
	exit 0
}


if test "$1" = '-h' -o "$1" = '--help' -o -z "$1"
then
	usage
fi


if test -n "$2"
then
	# use PATH optionnal param, remove trailing slash
	output="${2%/}"
else
	output="$HOME/static/$default"
fi

# create output necessary subfolder
mkdir -p "$output"

nice -19 zcat "$HOME/log/$1_access.log."*.gz | \
nice -19 goaccess --ignore-crawlers --html-report-title="$1 report" --anonymize-ip  "$HOME/log/$1_access.log" -a -o "$output/$1.html"

if test -n "$2"
then
	echo "📊 result exported to $2"
else
	echo "📊 result published: https://static.club1.fr/$USER/$default/$1.html"
fi
