FROM php:8.2.27-fpm-alpine AS builder

USER root

RUN apk add --no-cache --virtual .build-deps \
file \
autoconf \
dpkg-dev dpkg \
g++ \
gcc \
libc-dev \
make \
pkgconf \
re2c \
bzip2-dev \
postgresql16-dev \
zip libzip libzip-dev \
freetype freetype-dev libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev libxpm libxpm-dev libwebp libwebp-dev \
openldap-dev libldap libsasl cyrus-sasl-dev \
gettext gettext-dev \
aspell-dev \
libxml2-dev \
libxslt-dev \
linux-headers \
libmemcached libmemcached-dev libmemcached-libs \
libmcrypt-dev \
lz4 lz4-dev liblzf liblzf-dev zstd zstd-dev \
rabbitmq-c rabbitmq-c-dev libpq libpq-dev \
libssh2-dev \
imagemagick imagemagick-dev

RUN docker-php-source extract && \
    mkdir -p /usr/src/php/ext/memcache && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/memcache-8.2.tgz | tar xvz -C "/usr/src/php/ext/memcache" --strip 1 && \
    mkdir -p /usr/src/php/ext/memcached && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/memcached-3.3.0.tgz | tar xvz -C "/usr/src/php/ext/memcached" --strip 1 && \
    mkdir -p /usr/src/php/ext/apcu && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/apcu-5.1.24.tgz | tar xvz -C "/usr/src/php/ext/apcu" --strip 1 && \
    mkdir -p /usr/src/php/ext/mcrypt && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/mcrypt-1.0.7.tgz | tar xvz -C "/usr/src/php/ext/mcrypt" --strip 1 && \
    mkdir -p /usr/src/php/ext/msgpack && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/msgpack-3.0.0.tgz | tar xvz -C "/usr/src/php/ext/msgpack" --strip 1 && \
    mkdir -p /usr/src/php/ext/igbinary && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/igbinary-3.2.16.tgz | tar xvz -C "/usr/src/php/ext/igbinary" --strip 1 && \
    mkdir -p /usr/src/php/ext/redis && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/redis-6.1.0.tgz | tar xvz -C "/usr/src/php/ext/redis" --strip 1 && \
    mkdir -p /usr/src/php/ext/xhprof && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/xhprof-2.3.10.tgz | tar xvz -C "/usr/src/php/ext/xhprof" --strip 1 && \
    mkdir -p /usr/src/php/ext/xdebug && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/xdebug-3.4.1.tgz | tar xvz -C "/usr/src/php/ext/xdebug" --strip 1 && \
    mkdir -p /usr/src/php/ext/amqp && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/amqp-2.1.2.tgz | tar xvz -C "/usr/src/php/ext/amqp" --strip 1 && \
    mkdir -p /usr/src/php/ext/ssh2 && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/ssh2-1.4.1.tgz | tar xvz -C "/usr/src/php/ext/ssh2" --strip 1 && \
    mkdir -p /usr/src/php/ext/imagick && curl -fsSL https://github.com/cyrax13/pecl.php.net/raw/main/imagick-3.7.0.tgz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 && \
    cp -fr /usr/src/php/ext/igbinary /usr/local/include/php/ext/igbinary && \
    cp -fr /usr/src/php/ext/msgpack /usr/local/include/php/ext/msgpack

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-xpm --with-webp && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-configure redis --enable-redis-igbinary --enable-redis-msgpack --enable-redis-lzf --enable-redis-zstd

RUN docker-php-ext-install mysqli pdo_mysql bz2 pgsql pdo_pgsql zip gd opcache ldap exif intl calendar sodium gettext pspell xml xmlwriter xsl shmop sysvmsg sysvsem sysvshm sockets memcache memcached apcu mcrypt msgpack igbinary redis xhprof xdebug amqp ssh2 imagick

FROM php:8.2.27-fpm-alpine AS production

USER root

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=builder /usr/local/etc/ /usr/local/etc/

RUN mkdir -p /etc/periodic/1min && \
    mkdir -p /opt/msmtp/

COPY bitrix.sh /etc/periodic/1min/bitrix

COPY msmtprc /opt/msmtp/.msmtprc

RUN docker-php-source delete && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing catdoc && \
    apk add --no-cache msmtp curl openssl ca-certificates tzdata poppler-utils aspell bzip2 gettext libmcrypt libldap libsasl cyrus-sasl libmemcached libmemcached-libs icu-libs libxslt freetype libpng libjpeg-turbo libxpm libwebp libgomp zip libzip libxml2 lz4 liblzf zstd libpq rabbitmq-c libssh2 imagemagick && \
    curl -fsSL https://getcomposer.org/download/latest-stable/composer.phar -o composer.phar && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    echo "*       *       *       *       *       run-parts /etc/periodic/1min" >> /etc/crontabs/root && \
    sed -i '/^$/d' /etc/crontabs/root && \
    echo "" >> /etc/crontabs/root && \
    chmod -R a+x /etc/periodic/1min/bitrix && \
    chmod 600 /opt/msmtp/.msmtprc && \
    ln -s /opt/msmtp/.msmtprc /etc/msmtprc

RUN addgroup -g 979 bitrix && \
    adduser -D -u 979 -G bitrix bitrix

RUN mkdir -pv /opt/www /opt/.bx_temp /opt/browscap /opt/geoip2 /ssl && \
    chown -R bitrix:bitrix /usr/local/etc && \
    chown -R bitrix:bitrix /opt/www && \
    chown -R bitrix:bitrix /opt/.bx_temp && \
    chown -R bitrix:bitrix /opt/msmtp && \
    chown -R bitrix:bitrix /opt/browscap && \
    chown -R bitrix:bitrix /opt/geoip2 && \
    chown -R bitrix:bitrix /ssl

USER bitrix:bitrix
