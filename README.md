php.docker
==========

* Alpine 3.23
* PHP 8.5
* Apache 2
* Symfony LTS ready

ENV Variables
-------------

### `PHP_MEMORY_LIMIT`
- **Purpose**: Sets the PHP memory limit
- **Default**: `512M` (if not specified)
- **Usage**: Controls how much memory PHP scripts can allocate
- **Example**: `PHP_MEMORY_LIMIT=1G`

### `PHP_UPLOAD_MAX_FILESIZE`
- **Purpose**: Sets the maximum file upload size
- **Default**: `128M` (if not specified)
- **Usage**: Controls the maximum size of uploaded files
- **Example**: `PHP_UPLOAD_MAX_FILESIZE=256M`

### `PHP_POST_MAX_SIZE`
- **Purpose**: Sets the maximum POST data size
- **Default**: `128M` (if not specified)
- **Usage**: Controls the maximum size of POST request data
- **Example**: `PHP_POST_MAX_SIZE=256M`

### `DUMP_COMPOSER_ENV`
- **Purpose**: Controls whether composer environment is dumped on container startup
- **Default**: `0` (if not specified)
- **Usage**: When set to "1", runs `composer dump-env prod` command
- **Example**: `DUMP_COMPOSER_ENV=1`

### `RUN_DOCTRINE_MIGRATIONS`
- **Purpose**: Controls whether Doctrine database migrations are automatically executed on container startup
- **Default**: Not run (if not specified or not set to "1")
- **Usage**: When set to "1", runs `doctrine:migrations:migrate --all-or-nothing -n` command
- **Example**: `RUN_DOCTRINE_MIGRATIONS=1`
- **Note**: Migrations are executed as the `www-data` user and use the `--all-or-nothing` flag for transaction safety
