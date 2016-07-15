#!/bin/ash
set -e

if [ ! -e '/var/www/html/version.php' ]; then
	cp -r /usr/src/owncloud/* .

	chown -R www-data /var/www/html
fi

exec "$@"
