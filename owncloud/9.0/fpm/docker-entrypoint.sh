#!/bin/ash
set -e

if [ ! -e '/var/www/owncloud/version.php' ]; then
	cp -r /usr/src/owncloud/* .

	chown -R www-data /var/www/owncloud

	# force CAS authentication 
	if [ "$ENABLE_CAS" = true ]; then
		sed -i "6 i\ <default_enable/>" /var/www/owncloud/apps/user_cas/appinfo/info.xml
	fi
fi

exec "$@"
