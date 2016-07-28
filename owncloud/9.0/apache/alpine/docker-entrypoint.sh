#!/bin/ash
set -e

if [ ! -e '/var/www/html/owncloud/version.php' ]; then
	cp -r /usr/src/owncloud .

	chown -R apache:www-data /var/www/html
fi

exec "$@"