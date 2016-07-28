#!/bin/ash
set -e

if [ ! -e '/var/www/owncloud/version.php' ]; then
	cp -r /usr/src/owncloud/* .

	chown -R www-data /var/www/owncloud
fi

exec "$@"
