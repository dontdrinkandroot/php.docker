#!/bin/sh

MEMORY_LIMIT=${MEMORY_LIMIT:-512M}
UPLOAD_MAX_FILESIZE=${UPLOAD_MAX_FILESIZE:-128M}
POST_MAX_SIZE=${POST_MAX_SIZE:-128M}

echo "memory_limit = $MEMORY_LIMIT" > /etc/php84/conf.d/05_memory_limit.ini
echo "Set memory limit to $MEMORY_LIMIT"
echo "upload_max_filesize = $UPLOAD_MAX_FILESIZE" > /etc/php84/conf.d/05_upload_max_filesize.ini
echo "Set upload_max_filesize to $UPLOAD_MAX_FILESIZE"
echo "post_max_size = $POST_MAX_SIZE" > /etc/php84/conf.d/05_post_max_size.ini
echo "Set post_max_size to $POST_MAX_SIZE"

echo "Dumping env for composer"
su -s /bin/sh www-data -c "composer dump-env prod"

if [ "${RUN_MIGRATIONS:-0}" = "1" ]; then
    echo "Running database migrations"
    su -s /bin/sh www-data -c "bin/console doctrine:migrations:migrate --all-or-nothing -n"
else
    echo "Skipping database migrations"
fi

exec "$@"
