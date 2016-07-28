#!/bin/bash
set -e

if [ ! -e '/var/www/html/owncloud/version.php' ]; then
	mkdir /var/www/html/owncloud
	cd owncloud
	tar cf - --one-file-system -C /usr/src/owncloud . | tar xf -
	chown -R www-data /var/www/html
fi

exec "$@"
