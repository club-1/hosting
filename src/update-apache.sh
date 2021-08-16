#!/bin/bash
cd /etc/apache2/sites-available
for f in *-le-ssl.conf
do
	http=${f%-le-ssl.conf}.conf
	https=$f

	sed $https -E \
	-e 's/<(VirtualHost.*)\:443>/<\1:8080>/g' \
	-e '/letsencrypt/d' \
	| awk 'NF {p=1} p' | tac | awk 'NF {p=1} p' | tac \
	| awk 'NR>2 {print last} {last=$0}' \
	> $http

	a2dissite $https
	rm $https
done
