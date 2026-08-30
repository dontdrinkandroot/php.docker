# AGENTS.md

## Project Overview

`php.docker` builds and publishes reusable Docker images for PHP development and deployment. The repository contains two image families:

- `build/`: a general-purpose PHP 8.5 build image based on Alpine Linux, with Composer, Node.js, pnpm/yarn, common PHP extensions, and Xdebug.
- `symfony/`: FrankenPHP images for Symfony applications, based on FrankenPHP 1.12.7 and PHP 8.5.

There is no application source code, Composer project, JavaScript project, or automated unit-test suite in this repository. Changes primarily affect Docker build inputs, runtime shell scripts, PHP configuration, and Caddy configuration.

## Repository Layout

- `README.md`: supported images, variants, environment variables, and runtime features.
- `build/Dockerfile`: general-purpose PHP build image.
- `build/files/`: configuration and helper files copied into the build image, including `memory-limit.ini` which hardcodes `memory_limit = 512M`.
- `symfony/Dockerfile`: multi-stage FrankenPHP image definition.
- `symfony/files/docker-entrypoint`: runtime wrapper that writes PHP settings, clears Symfony cache, optionally dumps Composer environment, and optionally runs Doctrine migrations before delegating to the upstream entrypoint.
- `symfony/files/*.ini`: PHP configuration for assertions, Xdebug, and production tuning.
- `symfony/files/*.Caddyfile`: development and production Caddy/FrankenPHP configuration.
- `symfony/files/caddy-*`: runtime helpers for SPA rewrites and Messenger consumers.
- `build.sh`: builds all local image variants using the current Git branch in each tag.
- `deploy.sh`: pushes the four tags produced by `build.sh`.
- `.github/workflows/main.yaml`: builds and publishes all images to Docker Hub and GHCR on branch pushes, weekly schedule, or manual dispatch.

## Symfony Dockerfile

The Symfony Dockerfile has three usable targets:

- `base`: custom FrankenPHP binary with `caddy-cbrotli` and `caddy-supervisor`, Composer, and required PHP extensions. It exposes ports `80`, `443`, and `443/udp`.
- `dev`: development `php.ini`, Xdebug, Node.js 24, pnpm, assertions, and the development Caddyfile. It defaults `RUN_DOCTRINE_MIGRATIONS=0` and `DUMP_COMPOSER_ENV=0`.
- `prod`: production `php.ini`, supervisor directory, production PHP tuning, production Caddyfile, and startup tasks enabled by default. It defaults `RUN_DOCTRINE_MIGRATIONS=1` and `DUMP_COMPOSER_ENV=1`.

The build context for this Dockerfile is `symfony/`, not the repository root. Files referenced by `COPY` must remain inside that context. The custom binary is built with CGO enabled and FrankenPHP/Caddy modules compiled through `xcaddy`; changes to upstream versions or modules can substantially affect build time and compatibility.

## Common Commands

Build every image locally:

```sh
./build.sh
```

Build one target directly:

```sh
docker build --progress=plain --pull -t local/symfony-base -f symfony/Dockerfile --target base symfony/
docker build --progress=plain --pull -t local/symfony-dev -f symfony/Dockerfile --target dev symfony/
docker build --progress=plain --pull -t local/symfony-prod -f symfony/Dockerfile --target prod symfony/
```

Build the general-purpose image:

```sh
docker build --progress=plain --pull -t local/php-build -f build/Dockerfile build/
```

Push the branch-tagged images, only when explicitly intended:

```sh
./deploy.sh
```

There are no repository test commands. The minimum useful validation for Dockerfile or copied runtime-file changes is to build the affected target with `docker build`. Prefer `--progress=plain` for actionable build output. If Docker is unavailable, perform static checks and state that the image build could not be run.

## Runtime Contract

The Symfony image uses `/app` as its working directory and runs as `www-data` in the `dev` and `prod` targets. The entrypoint is `/usr/local/bin/docker-entrypoint`; the default command runs FrankenPHP with `/etc/frankenphp/Caddyfile`.

The entrypoint applies these environment variables:

- `PHP_MEMORY_LIMIT` defaults to `512M`.
- `PHP_UPLOAD_MAX_FILESIZE` defaults to `128M`.
- `PHP_POST_MAX_SIZE` defaults to `146M`.
- `PHP_MAX_EXECUTION_TIME` defaults to `30` seconds.
- `DUMP_COMPOSER_ENV=1` runs `composer dump-env prod` at startup.
- `RUN_DOCTRINE_MIGRATIONS=1` waits for `DATABASE_URL`, checks database connectivity for up to 60 seconds, and runs all-or-nothing migrations when migration files exist.

Startup work is only performed when the first argument is `frankenphp`, `php`, or `bin/console`. Preserve this behavior unless intentionally changing how ad hoc container commands work. The entrypoint always ends by delegating to `docker-php-entrypoint` with `exec`.

## Change Guidelines

- Keep Docker build contexts and `COPY` paths correct. A file added outside `build/` or `symfony/` cannot be copied by those Dockerfiles without changing the context and build workflows.
- Keep `dev` and `prod` behavior explicit. Changes to `base` are inherited by both variants and may affect production.
- Preserve executable permissions for shell helpers copied with `--chmod=755`.
- Keep shell scripts POSIX `sh` compatible; they run inside minimal container images.
- Avoid embedding credentials, registry tokens, or environment-specific secrets in Dockerfiles, workflows, or image layers.
- Update `README.md` when changing image tags, exposed ports, supported extensions, environment variables, startup behavior, or user-visible features.
- Do not push images as part of ordinary validation. `deploy.sh` publishes to registries and should only be used for an intentional release/publish operation.
- Do not modify generated IDE metadata under `.idea/` unless the task specifically requires it.

## CI and Image Tags

GitHub Actions sanitizes branch names before using them in tags, replacing slashes and unsupported characters. The local `build.sh` and `deploy.sh` scripts use the raw current branch name, so branch names containing characters invalid for Docker tags may require manual handling locally. CI publishes each image to both Docker Hub (`dontdrinkandroot/php`) and GHCR (`ghcr.io/<repository-owner>/php`).

## Self-Update Instruction

This guidelines file is a living document and MUST be actively maintained by the LLM Agent.

* **Trigger:** Whenever significant changes are made to the tech stack, project structure, coding guidelines, or key features, the LLM Agent MUST immediately update this file (`AGENTS.md`) to reflect the current state of the project.
* **Content:** 
    * Add any information that could have helped the agent to solve the task more efficiently or in fewer steps.
    * Remove outdated, obsolete, or incorrect information.
    * Ensure all tech stack versions and library names are accurate.
    * Make sure the most important features are clearly documented.
    * Keep the project structure up to date so that the most important files and directories are visible at a glance.
* **Proactivity:** Do not wait for explicit instructions to update these guidelines if you identify a discrepancy between the guidelines and the actual codebase.
