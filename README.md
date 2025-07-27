php.docker
==========

* Alpine 3.22
* PHP 8.4
* Apache 2
* Symfony LTS ready

ENV Variables
-------------

### `MEMORY_LIMIT`
- **Purpose**: Sets the PHP memory limit
- **Default**: `512M` (if not specified)
- **Usage**: Controls how much memory PHP scripts can allocate
- **Example**: `MEMORY_LIMIT=1G`

### `UPLOAD_MAX_FILESIZE`
- **Purpose**: Sets the maximum file upload size
- **Default**: `128M` (if not specified)
- **Usage**: Controls the maximum size of uploaded files
- **Example**: `UPLOAD_MAX_FILESIZE=256M`

### `POST_MAX_SIZE`
- **Purpose**: Sets the maximum POST data size
- **Default**: `128M` (if not specified)
- **Usage**: Controls the maximum size of POST request data
- **Example**: `POST_MAX_SIZE=256M`
- **Note**: There appears to be a typo in the entrypoint script where it checks for `POST_MAX_XIZE` but uses `POST_MAX_SIZE`

### `RUN_MIGRATIONS`
- **Purpose**: Controls whether Doctrine database migrations are automatically executed on container startup
- **Default**: Not run (if not specified or not set to "1")
- **Usage**: When set to "1", runs `doctrine:migrations:migrate --all-or-nothing -n` command
- **Example**: `RUN_MIGRATIONS=1`
- **Note**: Migrations are executed as the `www-data` user and use the `--all-or-nothing` flag for transaction safety
