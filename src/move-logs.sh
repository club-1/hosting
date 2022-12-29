cd /etc/apache2/sites-available
grep 'ErrorLog /home' * --files-with-matches | while read f
do
	domain=${f%.conf}
	old_error=$(grep -Eo '/home/.*error.log' "$f")
	old_access=$(grep -Eo '/home/.*access.log' "$f")
	sed -i -E "$f" \
		-e "s/\/home\/([^\/]+)\/.*error.log/\/home\/\1\/log\/$domain\_error.log/" \
		-e "s/\/home\/([^\/]+)\/.*access.log/\/home\/\1\/log\/$domain\_access.log/"
	new_error=$(grep -Eo '/home/.*error.log' "$f")
	new_access=$(grep -Eo '/home/.*access.log' "$f")
	log_dir=$(dirname "$new_error")
	user=$(basename $(dirname "log_dir"))
	mkdir -p "$log_dir"
	chmod 750 "$log_dir"
	mv "$old_error" "$new_error"
	mv "$old_access" "$new_access"
done
