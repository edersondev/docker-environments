#!/bin/bash
set -e

SITE_CONF=/usr/local/apache2/conf/httpd.conf
PATH_ROOT=/usr/local/apache2/htdocs

if [ -n "$SERVER_NAME" ]; then
	sed -i 's#$SERVER_NAME#'$SERVER_NAME'#g' $SITE_CONF
else
	sed -i 's#$SERVER_NAME#localhost#g' $SITE_CONF
fi

if [ -n "$DOCUMENT_ROOT" ]; then
	NEW_PATH="${PATH_ROOT}/${DOCUMENT_ROOT}"
	sed -i 's#$DOCUMENT_ROOT#'$NEW_PATH'#g' $SITE_CONF
else
	sed -i 's#$DOCUMENT_ROOT#'$PATH_ROOT'#g' $SITE_CONF
fi

exec "$@"
