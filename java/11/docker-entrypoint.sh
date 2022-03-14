#!/bin/bash
set -e
java -jar /$name_file_jar
exec "$@"
