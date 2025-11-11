FROM ghcr.io/roadrunner-server/roadrunner:2025.1.4 as roadrunner

FROM php:8.4-alpine3.21

RUN apk update && \
    apk add --no-cache bash htop grep nano coreutils curl git

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    @composer opcache mbstring zip \
    intl sockets protobuf pcntl \
    pdo_dblib pdo_mysql pdo_pgsql \
    imagick bcmath fileinfo \
    json redis rdkafka iconv

RUN IPE_GD_WITH=avif,jpeg,webp,freetype,heif install-php-extensions gd

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

EXPOSE 8080 80