#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM nginx:1.28.0-alpine-slim

ENV NJS_VERSION=0.8.10
ENV NJS_RELEASE=1
ENV BROTLI_VERSION=1.1.0
ENV GEOIP2_VERSION=3.4
ENV HEADERSMORE_VERSION=0.38
ENV ZIP_VERSION=1.3.0
ENV NDK_VERSION=0.3.3
ENV LUA_VERSION=0.10.28

COPY brotli_makefile /tmp/brotli_makefile
COPY brotli_shasum /tmp/brotli_shasum
COPY brotli_version /tmp/brotli_version
COPY nginx-module-brotli.xml /tmp/nginx-module-brotli.xml
COPY Makefile.module-brotli /tmp/Makefile.module-brotli

RUN chown nobody:nobody /tmp/brotli_makefile && \
    chown nobody:nobody /tmp/brotli_shasum && \
    chown nobody:nobody /tmp/brotli_version && \
    chown nobody:nobody /tmp/nginx-module-brotli.xml && \
    chown nobody:nobody /tmp/Makefile.module-brotli

COPY headersmore_shasum /tmp/headersmore_shasum
COPY headersmore_version /tmp/headersmore_version
COPY nginx-module-headers-more.xml /tmp/nginx-module-headers-more.xml

RUN chown nobody:nobody /tmp/headersmore_shasum && \
    chown nobody:nobody /tmp/headersmore_version && \
    chown nobody:nobody /tmp/nginx-module-headers-more.xml

COPY nginx-module-zip.copyright /tmp/nginx-module-zip.copyright
COPY nginx-module-zip.xml /tmp/nginx-module-zip.xml
COPY Makefile.module-zip /tmp/Makefile.module-zip
COPY mod_zip-${ZIP_VERSION}.tar.gz /tmp/mod_zip-${ZIP_VERSION}.tar.gz

RUN chown nobody:nobody /tmp/nginx-module-zip.copyright && \
    chown nobody:nobody /tmp/nginx-module-zip.xml && \
    chown nobody:nobody /tmp/Makefile.module-zip && \
    chown nobody:nobody /tmp/mod_zip-${ZIP_VERSION}.tar.gz

RUN set -x \
    && apkArch="$(cat /etc/apk/arch)" \
    && nginxPackages=" \
        nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-r${DYNPKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-r${DYNPKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-r${DYNPKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${NJS_RELEASE} \
        nginx-module-perl=${NGINX_VERSION}-r${DYNPKG_RELEASE} \
        nginx-module-brotli=${NGINX_VERSION}.${BROTLI_VERSION}-r${PKG_RELEASE} \
        nginx-module-geoip2=${NGINX_VERSION}.${GEOIP2_VERSION}-r${PKG_RELEASE} \
        nginx-module-ndk=${NGINX_VERSION}.${NDK_VERSION}-r${PKG_RELEASE} \
        nginx-module-lua=${NGINX_VERSION}.${LUA_VERSION}-r${PKG_RELEASE} \
        nginx-module-headers-more=${NGINX_VERSION}.${HEADERSMORE_VERSION}-r${PKG_RELEASE} \
        nginx-module-zip=${NGINX_VERSION}.${ZIP_VERSION}-r${PKG_RELEASE} \
    " \
# install prerequisites for public key and pkg-oss checks
    && apk add --no-cache --virtual .checksum-deps \
        openssl \
    && case "$apkArch" in \
        i386) \
# arches officially built by upstream
            apk add -X "https://nginx.org/packages/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
            ;; \
        *) \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
            set -x \
            && tempDir="$(mktemp -d)" \
            && chown nobody:nobody $tempDir \
            && apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre2-dev \
                zlib-dev \
                linux-headers \
                libxslt-dev \
                gd-dev \
                geoip-dev \
                libedit-dev \
                bash \
                alpine-sdk \
                findutils \
                curl \
                cmake \
                wget \
                brotli-dev \
                libmaxminddb \
                libmaxminddb-dev \
                libzip-dev \
                xz \
                xz-dev \
                pcre \
                pcre-dev \
                perl-dev \
            && su nobody -s /bin/sh -c " \
                export HOME=${tempDir} \
                && cd ${tempDir} \
                && curl -f -L -O https://github.com/nginx/pkg-oss/archive/${NGINX_VERSION}-${PKG_RELEASE}.tar.gz \
                && PKGOSSCHECKSUM=\"517bc18954ccf4efddd51986584ca1f37966833ad342a297e1fe58fd0faf14c5a4dabcb23519dca433878a2927a95d6bea05a6749ee2fa67a33bf24cdc41b1e4 *${NGINX_VERSION}-${PKG_RELEASE}.tar.gz\" \
                && if [ \"\$(openssl sha512 -r ${NGINX_VERSION}-${PKG_RELEASE}.tar.gz)\" = \"\$PKGOSSCHECKSUM\" ]; then \
                    echo \"pkg-oss tarball checksum verification succeeded!\"; \
                else \
                    echo \"pkg-oss tarball checksum verification failed!\"; \
                    exit 1; \
                fi \
                && tar xzvf ${NGINX_VERSION}-${PKG_RELEASE}.tar.gz \
                && cd pkg-oss-${NGINX_VERSION}-${PKG_RELEASE} \
                && cd alpine \
                && sed -i 's/.*BASE_MODULES=.*/BASE_MODULES=   geoip image-filter njs perl xslt brotli headers-more geoip2 ndk lua zip /' ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/alpine/Makefile \
                && mv -f /tmp/brotli_makefile ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/contrib/src/ngx_brotli/Makefile \
                && mv -f /tmp/brotli_shasum ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/contrib/src/ngx_brotli/SHA512SUMS \
                && mv -f /tmp/brotli_version ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/contrib/src/ngx_brotli/version \
                && mv -f /tmp/nginx-module-brotli.xml ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/docs/ \
                && mv -f /tmp/Makefile.module-brotli ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/alpine/Makefile.module-brotli \
                && mv -f /tmp/headersmore_shasum ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/contrib/src/headers-more-nginx-module/SHA512SUMS \
                && mv -f /tmp/headersmore_version ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/contrib/src/headers-more-nginx-module/version \
                && mv -f /tmp/nginx-module-headers-more.xml ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/docs/ \
                && mv /tmp/Makefile.module-zip ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/alpine/ \
                && mv /tmp/mod_zip-${ZIP_VERSION}.tar.gz ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/contrib/tarballs/ \
                && mv /tmp/nginx-module-zip.copyright ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/docs/ \
                && mv /tmp/nginx-module-zip.xml ${tempDir}/pkg-oss-${NGINX_VERSION}-${PKG_RELEASE}/docs/ \
                && make module-geoip module-image-filter module-njs module-perl module-xslt module-brotli module-headers-more module-geoip2 module-ndk module-lua module-zip \
                && apk index --allow-untrusted -o ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz ${tempDir}/packages/alpine/${apkArch}/*.apk \
                && abuild-sign -k ${tempDir}/.abuild/abuild-key.rsa ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz \
                " \
            && cp ${tempDir}/.abuild/abuild-key.rsa.pub /etc/apk/keys/ \
            && apk del --no-network .build-deps \
            && apk add -X ${tempDir}/packages/alpine/ --no-cache $nginxPackages \
            && mkdir -p /root/packages/ \
            && cp -R ${tempDir}/packages/alpine/* /root/packages/ \
            && cp ${tempDir}/.abuild/abuild-key.rsa.pub /root/packages/${apkArch} \
            ;; \
    esac \
# remove checksum deps
    && apk del --no-network .checksum-deps \
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
    && if [ -f "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi \
# Bring in curl and ca-certificates to make registering on DNS SD easier
    && apk add --no-cache tzdata curl ca-certificates openssl \
    && rm -rf /tmp/*

VOLUME ["/root/packages/"]
