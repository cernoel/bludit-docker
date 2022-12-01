#!/bin/sh

echo "[+] Starting services ..."

echo "  - php-fpm ..."
php-fpm8 --daemonize

echo "  - nginx ..."
nginx -g "daemon off;"
