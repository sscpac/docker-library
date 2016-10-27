#!/bin/ash
set -e

if [ ! -e '/var/www/owncloud/version.php' ]; then
	# force CAS authentication 
	if [ "$ENABLE_CAS" = true ]; then
		sed -i "6 i\ <default_enable/>" /var/www/owncloud/apps/user_cas/appinfo/info.xml
	fi
fi

exec "$@"
