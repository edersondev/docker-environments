#!/bin/bash
set -e
PATH_ROOT=/var/angular
if [ -f "$PATH_ROOT/package.json" ]; then
	if [ ! -d "$PATH_ROOT/node_modules" ];then
		npm install --verbose
	fi
fi
exec "$@"
