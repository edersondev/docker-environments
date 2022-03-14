#!/bin/bash
set -e

SITE_CONF=/etc/nginx/conf.d/default.conf
PATH_ROOT=/var/www/html

if [ -n "$SERVER_NAME" ]; then
	sed -i 's#$SERVER_NAME#'$SERVER_NAME'#g' $SITE_CONF
else
	sed -i 's#$SERVER_NAME#localhost#g' $SITE_CONF
fi

if [ -n "$DOCUMENT_ROOT" ]; then
	NEW_PATH="${PATH_ROOT}/${DOCUMENT_ROOT}"
	sed -i 's#$APP_ROOT#'$NEW_PATH'#g' $SITE_CONF
else
	sed -i 's#$APP_ROOT#'$PATH_ROOT'#g' $SITE_CONF
fi

if [ -n "$PHP_FPM" ]; then
	sed -i 's#$PHP_FPM#'$PHP_FPM'#g' $SITE_CONF
else
	sed -i 's#$PHP_FPM#fpm#g' $SITE_CONF
fi

exec "$@"