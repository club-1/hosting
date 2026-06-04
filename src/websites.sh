#!/bin/sh -e
# list all websites hosted on the server

grep -i redirect --files-without-match -R /etc/apache2/sites-enabled | xargs basename -a -s.conf | sed -E 's#(.*)#https://\1/#'
