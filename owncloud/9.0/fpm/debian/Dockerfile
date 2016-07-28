FROM php:5.6-fpm
MAINTAINER SSC Pacific

RUN apt-get update && apt-get install -y \
	bzip2 \
	libcurl4-openssl-dev \
	libfreetype6-dev \
	libicu-dev \
	libjpeg-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libpng12-dev \
	libpq-dev \
	libxml2-dev \
	&& rm -rf /var/lib/apt/lists/*

# https://doc.owncloud.org/server/8.1/admin_manual/installation/source_installation.html#prerequisites
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd exif intl mbstring mcrypt mysql opcache pdo_mysql pdo_pgsql pgsql zip

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
RUN pecl install APCu-4.0.10 redis-2.2.8 memcached \
	&& docker-php-ext-enable apcu redis memcached

ENV OWNCLOUD_VERSION 9.0.2
VOLUME /var/www/owncloud
WORKDIR /var/www/owncloud

# Install sscpac/owncloud-core, sscpac/owncloud-calendar, and owncloud/owncloud-3rdparty
# using source release from GitHub. Eventually the sscpac/owncloud-* should be built from
# source and resulting tar should be uploaded to a website
#
RUN curl -fsSL -o owncloud.tar.gz \
        "https://github.com/sscpac/owncloud-core/archive/v9.0.2-sscpac.tar.gz" \
#	&& curl -fsSL -o owncloud.tar.bz2.asc \
#		"https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2.asc" \
#	&& export GNUPGHOME="$(mktemp -d)" \
# gpg key from https://owncloud.org/owncloud.asc
#	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys E3036906AD9F30807351FAC32D5D5E97F6978A26 \
#	&& gpg --batch --verify owncloud.tar.bz2.asc owncloud.tar.bz2 \
#	&& rm -r "$GNUPGHOME" owncloud.tar.bz2.asc \
	&& tar -xzf owncloud.tar.gz -C /usr/src/ \
	&& mv /usr/src/owncloud-core-9.0.2-sscpac /usr/src/owncloud \
	&& rm owncloud.tar.gz \ 
	&& cd /usr/src/owncloud \
	&& rm -rf *.md COPYING-README *.sh *.json build tests \
	&& cd /tmp \ 
	# 3rd party libraries that owncloud depends upon and stored in separate repo and not packaged with sscpac release.
	# this will fail if owncloud deletes the release.  May want to fork the repo
	&& curl -fsSL -o 3rdparty.tar.gz \ 
	    "https://github.com/owncloud/3rdparty/archive/v9.0.2.tar.gz" \
	&& tar -xzf 3rdparty.tar.gz \
	&& mv 3rdparty-9.0.2/* /usr/src/owncloud/3rdparty/ \
	&& rm -rf 3rdparty* \
	# sscpac calendar application
	# eventually we should run the Makefile to package only the necessary files.   Makefile uses --exclude-vcs-ignores
	# that is not available with the base image's version of tar.  The ignores option excludes files in .gitignore
	&& curl -fsSL -o owncloud-calendar.tar.gz \ 
	    "https://github.com/sscpac/owncloud-calendar/archive/v1.0.tar.gz" \
	&& tar -xzf owncloud-calendar.tar.gz \
	&& mv ./owncloud-calendar-1.0/app /usr/src/owncloud/apps/calendar/ \
	&& rm -rf owncloud-calendar*  

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
