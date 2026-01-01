#!/bin/sh

set -e

PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-512M}
PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-128M}
PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-128M}

echo "memory_limit = $PHP_MEMORY_LIMIT" > /etc/php85/conf.d/05_memory_limit.ini
echo "Set memory limit to $PHP_MEMORY_LIMIT"
echo "upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE" > /etc/php85/conf.d/05_upload_max_filesize.ini
echo "Set upload_max_filesize to $PHP_UPLOAD_MAX_FILESIZE"
echo "post_max_size = $PHP_POST_MAX_SIZE" > /etc/php85/conf.d/05_post_max_size.ini
echo "Set post_max_size to $PHP_POST_MAX_SIZE"

if [ "${DUMP_COMPOSER_ENV:-0}" = "1" ]; then
    echo "Dumping env for composer"
    su -s /bin/sh www-data -c "composer dump-env prod"
fi

if [ "${RUN_DOCTRINE_MIGRATIONS:-0}" = "1" ]; then
    if su -s /bin/sh www-data -c "bin/console doctrine:migrations:migrate --help" > /dev/null 2>&1; then
        echo "Running database migrations"
        su -s /bin/sh www-data -c "bin/console doctrine:migrations:migrate --all-or-nothing -n"
    else
        echo "Skipping database migrations - doctrine:migrations:migrate command not available"
    fi
else
    echo "Skipping database migrations"
fi

exec "$@"
