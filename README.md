RoadRunner PHP runtime Docker image

Overview

- This repository builds a PHP 8.4 image on Alpine Linux 3.21 prepared for running RoadRunner-based apps. It installs a
  curated set of PHP extensions commonly required for high‑performance HTTP workers and queues.

What’s included and versions

- Base OS: Alpine Linux 3.21 (from docker.io/library/php:8.4-alpine3.22)
- PHP: 8.4 (CLI, from the php:8.4-alpine3.21 base image)
- RoadRunner build stage: ghcr.io/roadrunner-server/roadrunner:2025.1.4 (build stage only; rr is not included in the
  final image unless explicitly copied)
- PHP extension installer: install-php-extensions (downloaded as "latest" at build time
  from https://github.com/mlocati/docker-php-extension-installer)
- Exposed ports: 8080, 80
- Base utilities installed: bash, htop, grep, nano, coreutils, curl, git
- `appuser` user created with UID 10001. Fully unprivileged.

PHP extensions installed
Installed via install-php-extensions in two steps:

1) Core set
    - @composer (Composer latest at build time)
    - opcache (default for php)
    - mbstring (default for php)
    - zip
    - intl
    - sockets
    - protobuf
    - pcntl
    - pdo_dblib
    - pdo_mysql
    - pdo_pgsql
    - imagick
    - bcmath
    - fileinfo (default for php)
    - json (default for php)
    - redis
    - rdkafka
    - iconv (default for php)

2) GD with specific features
    - gd built with: avif, jpeg, webp, freetype, heif

Notes on versions and reproducibility

- The PHP base image (8.4-alpine3.22) is pinned, ensuring consistent PHP/OS versions. The RoadRunner build stage (
  2025.1.4) is also pinned.
- The install-php-extensions script is fetched as "latest" at build time; the exact script version may change over time.
- Most PHP extensions are installed at the latest compatible versions (from Alpine packages or PECL) resolved during
  build.
- To achieve fully reproducible builds, consider pinning:
    - The installer script to a specific release URL, e.g. .../download/3.5.1/install-php-extensions
    - Specific PECL versions, e.g. install-php-extensions redis-6.0.2 rdkafka-6.0.3 imagick-3.7.0
    - Alpine package versions via apk add with explicit versions where applicable.

Run (example)

- docker run --rm -p 8080:8080 -p 80:80 amondar/roadrunner-php:{TAG}

File reference

- Dockerfile stages
    1) FROM ghcr.io/roadrunner-server/roadrunner:2025.1.4 AS RoadRunner — pulls the RoadRunner binary/tooling
    2) FROM php:8.4-alpine3.21 — base runtime (Alpine 3.21 + PHP 8.4)
- The install-php-extensions script is downloaded and used to install the listed extensions.
- Ports 8080 and 80 are exposed for typical HTTP usage with RoadRunner.

Troubleshooting

- If a specific extension fails to compile due to Alpine or PECL changes, pin its version as noted above.
- Ensure you have build tooling available in the image when adding new extensions (install-php-extensions handles most
  dependencies automatically).

License and credits

- RoadRunner is provided by the RoadRunner team: https://github.com/roadrunner-server
- PHP extension installer by mlocati: https://github.com/mlocati/docker-php-extension-installer
- Base PHP images by the Docker Official Images project.
