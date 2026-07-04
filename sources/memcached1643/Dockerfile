#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM alpine:3.24

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN set -eux; \
	addgroup -g 11211 memcache; \
	adduser -D -u 11211 -G memcache memcache

# ensure SASL's "libplain.so" is installed as per https://github.com/memcached/memcached/wiki/SASLHowto
RUN apk add --no-cache libsasl

ENV MEMCACHED_VERSION 1.6.43
ENV MEMCACHED_URL https://memcached.org/files/memcached-1.6.43.tar.gz
ENV MEMCACHED_SHA1 37307d13528f355fb282bc8841ca033272e44ac9

RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		ca-certificates \
		coreutils \
		cyrus-sasl-dev \
		dpkg-dev dpkg \
		gcc \
		libc-dev \
		libevent-dev \
		linux-headers \
		make \
		openssl \
		openssl-dev \
		perl \
		perl-io-socket-ssl \
		perl-utils \
	; \
	\
	wget -O memcached.tar.gz "$MEMCACHED_URL"; \
	echo "$MEMCACHED_SHA1  memcached.tar.gz" | sha1sum -c -; \
	mkdir -p /usr/src/memcached; \
	tar -xzf memcached.tar.gz -C /usr/src/memcached --strip-components=1; \
	rm memcached.tar.gz; \
	\
	cd /usr/src/memcached; \
	\
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
# https://github.com/memcached/memcached/issues/1220#issuecomment-2770251664: on arm32, we need to override the upstream alignment check (which fails to detect the need for alignment on arm32v6+ on our hardware for some reason, which then causes us to fail the tests 😭)
	case "$gnuArch" in \
		arm-*abihf) export ac_cv_c_alignment=need ;; \
	esac; \
	./configure \
		--build="$gnuArch" \
		--enable-extstore \
		--enable-proxy \
		--enable-sasl \
		--enable-sasl-pwdb \
		--enable-tls \
	; \
	nproc="$(nproc)"; \
	make -j "$nproc"; \
	\
# try the tests in parallel first, but many of them are resource-intensive, so fall back to serial
	make test PARALLEL="$nproc" || make test; \
	\
	make install; \
	\
	cd /; \
	rm -rf /usr/src/memcached; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-network --virtual .memcached-rundeps $runDeps; \
	apk del --no-network .build-deps; \
	\
	memcached -V

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

USER memcache
EXPOSE 11211
CMD ["memcached"]
