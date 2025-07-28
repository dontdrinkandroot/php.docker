#!/bin/sh

set -xe

MEMORY_LIMIT=${MEMORY_LIMIT:-512M}
UPLOAD_MAX_FILESIZE=${UPLOAD_MAX_FILESIZE:-128M}
POST_MAX_SIZE=${POST_MAX_SIZE:-128M}

echo "memory_limit = $MEMORY_LIMIT" > /etc/php84/conf.d/05_memory_limit.ini
echo "upload_max_filesize = $UPLOAD_MAX_FILESIZE" > /etc/php84/conf.d/05_upload_max_filesize.ini
echo "post_max_size = $POST_MAX_SIZE" > /etc/php84/conf.d/05_post_max_size.ini

su -s /bin/sh www-data -c "composer dump-env prod"

if [ "${RUN_MIGRATIONS:-0}" = "1" ]; then
    su -s /bin/sh www-data -c "bin/console doctrine:migrations:migrate --all-or-nothing -n"
else
    echo "Skipping database migrations"
fi

exec "$@"
