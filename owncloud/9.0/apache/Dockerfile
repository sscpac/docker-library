FROM php:5.6-alpine
MAINTAINER SSC Pacific

RUN apk add --no-cache --no-progress --virtual .build-deps \
	    $PHPIZE_DEPS \
		curl-dev \ 
		freetype-dev \ 
		icu-dev \
		libjpeg-turbo-dev \
		libmcrypt-dev \
		libpng-dev \
		libxml2-dev  \
		postgresql-dev  \
	&& apk add --no-cache --no-progress \
		bzip2 \
		libmcrypt \ 
		icu \ 
		libpng \ 
		libjpeg \
		libpq \ 
		gd 

# https://doc.owncloud.org/server/8.1/admin_manual/installation/source_installation.html#prerequisites
RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \ 
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include  \
	&& docker-php-ext-install gd exif intl mbstring mcrypt mysql opcache pdo_mysql pgsql pdo_pgsql zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# PECL extensions
RUN set -ex \ 
        && pecl install APCu-4.0.10 \ 
        && pecl install redis-2.2.8 \
	    && docker-php-ext-enable apcu redis \  
	    && apk del .build-deps

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_ENVVARS /usr/sbin/envvars

RUN apk add --no-cache --no-progress \ 
			apache2 \
			apache2-utils \
			apache2-ssl \ 
			php5-apache2 \ 
			php5-ctype \
			php5-dom \
			php5-json \
			php5-gd \
			php5-iconv \
			php5-xml \
			php5-posix \
			php5-pdo \
			php5-pdo_pgsql \
			php5-pdo_mysql \
			php5-pdo_sqlite \
			php5-pgsql \
			php5-mysql \
			php5-sqlite3 \
			php5-zip \
			php5-zlib \
			php5-curl \
			php5-mcrypt \
			php5-intl \
			php5-openssl \
			php5-xmlreader \
		&& mkdir /var/www/html \ 
		&& mkdir /run/apache2

# logs should go to stdout / stderr
RUN set -ex \
	&& . "$APACHE_ENVVARS" \
	&& ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
	&& ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
	&& ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"

# container startup
COPY apache2-foreground /usr/local/bin/
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh /usr/local/bin/apache2-foreground

ENV OWNCLOUD_VERSION 9.0.2
ENV CALENDAR_VERSION 1.0
ENV USER_CAS_VERSION 1.0
ENV PHP_CAS_VERSION 1.3.4
ENV ENABLE_CAS false
WORKDIR /var/www/owncloud


# Install sscpac/owncloud-core, sscpac/owncloud-calendar, and owncloud/owncloud-3rdparty
# using source release from GitHub. Eventually the sscpac/owncloud-* should be built from
# source and resulting tar should be uploaded to a website
#
RUN curl -fsSL -o /tmp/owncloud.tar.gz \
        "https://github.com/sscpac/owncloud-core/archive/v${OWNCLOUD_VERSION}-sscpac.tar.gz" \
#	&& curl -fsSL -o owncloud.tar.bz2.asc \
#		"https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2.asc" \
#	&& export GNUPGHOME="$(mktemp -d)" \
# gpg key from https://owncloud.org/owncloud.asc
#	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys E3036906AD9F30807351FAC32D5D5E97F6978A26 \
#	&& gpg --batch --verify owncloud.tar.bz2.asc owncloud.tar.bz2 \
#	&& rm -r "$GNUPGHOME" owncloud.tar.bz2.asc \
	&& tar -xzf /tmp/owncloud.tar.gz -C /tmp/ \
	&& mv /tmp/owncloud-core-${OWNCLOUD_VERSION}-sscpac/* /var/www/owncloud/ \
	&& rm -rf /tmp/owncloud* \ 
	&& cd /var/www/owncloud \
	&& rm -rf *.md COPYING-README *.sh *.json build tests \
	&& cd /tmp \
	# 3rd party libraries that owncloud depends upon and stored in separate repo and not packaged with sscpac release.
	# this will fail if owncloud deletes the release.  May want to fork the repo
	&& curl -fsSL -o /tmp/3rdparty.tar.gz \ 
	    "https://github.com/owncloud/3rdparty/archive/v${OWNCLOUD_VERSION}.tar.gz" \
	&& tar -xzf /tmp/3rdparty.tar.gz -C /tmp/ \
	&& mv /tmp/3rdparty-${OWNCLOUD_VERSION}/* /var/www/owncloud/3rdparty/ \
	&& rm -rf /tmp/3rdparty* \
	# sscpac calendar application
	# eventually we should run the Makefile to package only the necessary files.   Makefile uses --exclude-vcs-ignores
	# that is not available with the base image's version of tar.  The ignores option excludes files in .gitignore
	&& curl -fsSL -o /tmp/owncloud-calendar.tar.gz \ 
	    "https://github.com/sscpac/owncloud-calendar/archive/v${CALENDAR_VERSION}.tar.gz" \
	&& tar -xzf /tmp/owncloud-calendar.tar.gz -C /tmp/ \
	&& mv /tmp/owncloud-calendar-${CALENDAR_VERSION}/app /var/www/owncloud/apps/calendar/ \
	&& rm -rf /tmp/owncloud-calendar* \
	# download user_cas dependency, phpCAS.  
	&& curl -fsSL -o /tmp/phpCAS.tar.gz "https://developer.jasig.org/cas-clients/php/${PHP_CAS_VERSION}/CAS-${PHP_CAS_VERSION}.tgz" \
	&& pear install /tmp/phpCAS.tar.gz \
	&& rm -rf /tmp/phpCAS* \
	# install user_cas application that defers owncloud authentication to CAS server
	&& curl -fsSL -o /tmp/user_cas.tar.gz "https://github.com/sscpac/user_cas/archive/v${USER_CAS_VERSION}.tar.gz" \
	&& tar -xzf /tmp/user_cas.tar.gz -C /tmp/ \
	&& mv /tmp/user_cas-${USER_CAS_VERSION}/app /var/www/owncloud/apps/user_cas/ \
	&& rm -rf /tmp/user_cas*  \
	# change ownership to non-root user 82 (www-data) and 'root' group (0) 
	&& chown -R 82:0 /var/www/owncloud \
	# allow users in 'root' group to read/write files and view directories
	# group 0 allows Openshift to run as arbitrary user in root group
	&& chmod -R g+rw /var/www/owncloud \ 
	&& find /var/www/owncloud -type d -exec chmod g+x {} + \
	&& chmod g+x /usr/local/bin/apache2-foreground \ 
	&& chmod g+w /var/log/ /run/apache2/ \
	# TODO enable ssl ...disable for now
	&& rm /etc/apache2/conf.d/ssl.conf \
	&& addgroup www-data root

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod g+x /entrypoint.sh

# run as non-root user, apache
USER 82
EXPOSE 8080 
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]