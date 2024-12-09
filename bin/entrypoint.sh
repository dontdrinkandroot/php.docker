#!/bin/sh

if [ -n "$MEMORY_LIMIT" ]; then
    echo "memory_limit = $MEMORY_LIMIT" > /etc/php84/conf.d/05_memory_limit.ini
else
    echo "memory_limit = 512M" > /etc/php84/conf.d/05_memory_limit.ini
fi

if [ -n "$UPLOAD_MAX_FILESIZE" ]; then
    echo "upload_max_filesize = $UPLOAD_MAX_FILESIZE" > /etc/php84/conf.d/05_upload_max_filesize.ini
else
    echo "upload_max_filesize = 128M" > /etc/php84/conf.d/05_upload_max_filesize.ini
fi

if [ -n "$POST_MAX_XIZE" ]; then
    echo "post_max_size = $POST_MAX_SIZE" > /etc/php84/conf.d/05_post_max_size.ini
else
    echo "post_max_size = 128M" > /etc/php84/conf.d/05_post_max_size.ini
fi

exec "$@"
