#!/bin/bash
set -e

if [ ! -e '/var/www/owncloud/version.php' ]; then
	tar cf - --one-file-system -C /usr/src/owncloud . | tar xf -
	chown -R www-data /var/www/owncloud
fi

exec "$@"
