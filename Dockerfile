FROM ghcr.io/roadrunner-server/roadrunner:2025.1.4 AS roadrunner

FROM php:8.4-alpine3.22

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk update && \
    apk add --no-cache bash htop grep nano coreutils curl git supercronic \
    && install-php-extensions \
    @composer opcache mbstring zip \
    intl sockets protobuf pcntl \
    pdo_dblib pdo_mysql pdo_pgsql \
    imagick bcmath fileinfo \
    json redis rdkafka iconv \
    && IPE_GD_WITH=avif,jpeg,webp,freetype,heif install-php-extensions gd \
    # create unprivileged user \
    && adduser \
            --disabled-password \
            --shell "/sbin/nologin" \
            --home "/nonexistent" \
            --no-create-home \
            --uid "10001" \
            --gecos "" \
            "appuser" \
    && mkdir /etc/supercronic \
    && echo '*/1 * * * * php /var/www/project/artisan schedule:run' > /etc/supercronic/project \
    # create directory for application sources and roadrunner unix socket \
    && mkdir -p /var/www/project /var/run/rr \
    && chown -R appuser:appuser /var/www/project /var/run/rr \
    && chmod -R 777 /var/run/rr \
    # make clean up \
    && docker-php-source delete \
    && apk del .build-deps \
    && rm -R /tmp/pear


COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

# use an unprivileged user by default
USER appuser:appuser

EXPOSE 8080 80

# unset default image entrypoint
ENTRYPOINT []