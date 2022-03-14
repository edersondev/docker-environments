#!/bin/bash
set -e

PATH_ROOT=/var/www/html

if [ -f "$PATH_ROOT/composer.json" ]; then
	if [ ! -d "$PATH_ROOT/vendor" ];then
		composer install
	fi
fi

exec "$@"
