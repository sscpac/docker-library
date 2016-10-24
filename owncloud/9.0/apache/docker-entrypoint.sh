#!/bin/ash
set -e

if [ ! -e '/var/www/html/owncloud/version.php' ]; then
	cp -r /usr/src/owncloud/* /var/www/html/ 

	chown -R apache:www-data /var/www/html

	# force CAS authentication 
	if [ "$ENABLE_CAS" = true ]; then
		sed -i "6 i\ <default_enable/>" /var/www/html/apps/user_cas/appinfo/info.xml
	fi
fi

exec "$@"
