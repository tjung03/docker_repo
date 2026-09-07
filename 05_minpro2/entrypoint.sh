#!/bin/bash
mkdir -p /run/php-fpm
/usr/sbin/php-fpm &
exec /usr/sbin/httpd -D FOREGROUND
