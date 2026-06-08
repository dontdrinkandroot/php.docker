# php.docker

Docker images for PHP development and deployment.

## Build Image

General-purpose PHP image based on Alpine 3.23 with PHP 8.5.

**Included tools:**
- Composer (global installation)
- PHPStan (globally installed)
- Node.js with pnpm and yarn

**PHP Extensions:**
apcu, ctype, curl, dom, exif, fileinfo, gd, iconv, intl, mbstring, openssl, pcntl, pdo_mysql, pdo_pgsql, pdo_sqlite, session, simplexml, sodium, tokenizer, xml, xmlwriter, zip, xdebug

**Usage:**
```bash
docker build -t my-build-image -f build/Dockerfile build/
```

---

## Symfony Images

FrankenPHP 1.12.1-based images for running Symfony applications with PHP 8.5.

### Variants

| Variant | Description |
|---------|-------------|
| **base** | Core runtime without Xdebug or additional tooling |
| **dev** | Development image with Xdebug, PHPStan, and pnpm |
| **prod** | Production image with supervisor support, security headers, and compression |

### Build

```bash
./build.sh
```

This builds all variants tagged with the current git branch name:
- `dontdrinkandroot/php:symfony-base-<branch>`
- `dontdrinkandroot/php:symfony-dev-<branch>`
- `dontdrinkandroot/php:symfony-prod-<branch>`

### Exposed Ports

- `80` (HTTP)
- `443` (HTTPS)
- `443/udp` (HTTP/3)

### Custom Caddy Modules

- [caddy-cbrotli](https://github.com/dunglas/caddy-cbrotli) - Brotli compression
- [caddy-supervisor](https://github.com/baldinof/caddy-supervisor) - Background process management

---

## Environment Variables

### `PHP_MEMORY_LIMIT`
- **Default**: `512M`
- Sets the PHP memory limit

### `PHP_UPLOAD_MAX_FILESIZE`
- **Default**: `128M`
- Maximum file upload size

### `PHP_POST_MAX_SIZE`
- **Default**: `146M`
- Maximum POST request data size

### `PHP_MAX_EXECUTION_TIME`
- **Default**: `30`
- Maximum PHP script execution time in seconds

### `DUMP_COMPOSER_ENV`
- **Default**: `0` (dev), `1` (prod)
- When `1`, runs `composer dump-env prod` on startup

### `RUN_DOCTRINE_MIGRATIONS`
- **Default**: `0` (dev), `1` (prod)
- When `1`, runs `doctrine:migrations:migrate --all-or-nothing` on startup
- Requires `DATABASE_URL` to be set
- Waits up to 60 seconds for database connectivity

---

## Production Features

The **prod** variant includes:
- Brotli and gzip compression
- Security headers (X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy)
- Supervisor support for background workers (e.g., Symfony Messenger consumers)
- Production-tuned PHP settings
- `composer dump-env prod` execution on startup
- Automatic Doctrine migrations

### Adding Messenger Consumer Workers

```bash
docker run -e MESSENGER_CONSUMER_COMMAND="messenger:consume async -vv" ...
```

### SPA Rewrite Support

The `caddy-add-spa-rewrite` script adds Caddy rewrite rules for single-page applications:

```bash
docker run -v /my/spa:/app/public ... \
  caddy-add-spa-rewrite /app /app/index.html
```

This rewrites non-existing paths under the given URL base path to the fallback path, enabling client-side routing.

---

## Development Features

The **dev** variant includes:
- Xdebug with IDE integration support
- PHPStan for static analysis
- pnpm for Node.js package management
- Development-optimized PHP configuration
