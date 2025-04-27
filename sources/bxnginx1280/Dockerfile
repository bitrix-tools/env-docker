FROM nginx:1.28.0-alpine-slim

USER root

RUN cd /root/ && \
    apk add --no-cache git curl openssl ca-certificates tzdata && \
    git clone https://github.com/cyrax13/nginx-modules.git && \
    cp /root/nginx-modules/packages/1.28.0/v1/alpine/v3.21/main/$(uname -m)/abuild-key.rsa.pub /etc/apk/keys/ && \
    echo "/root/nginx-modules/packages/1.28.0/v1/alpine/v3.21/main" >> /etc/apk/repositories && \
    apk update && \
    apk add nginx-module-xslt nginx-module-geoip nginx-module-image-filter nginx-module-njs nginx-module-perl nginx-module-brotli nginx-module-geoip2 nginx-module-ndk nginx-module-lua nginx-module-headers-more nginx-module-zip && \
    apk del git && \
    sed -i "s/.*1.28.0.*//" /etc/apk/repositories && \
    rm -f /etc/apk/keys/abuild-key.rsa.pub && \
    rm -rf /root/nginx-modules

RUN addgroup -g 979 bitrix && \
    adduser -D -u 979 -G bitrix bitrix

RUN mkdir -pv /opt/www /opt/.bx_temp /opt/msmtp /opt/browscap /opt/geoip2 /ssl /var/runs/nginx && \
    chown -R bitrix:bitrix /var/log/nginx && \
    chown -R bitrix:bitrix /var/cache/nginx && \
    chown -R bitrix:bitrix /var/runs/nginx && \
    chown -R bitrix:bitrix /usr/lib/nginx/modules && \
    chown -R bitrix:bitrix /etc/nginx && \
    chown -R bitrix:bitrix /opt/www && \
    chown -R bitrix:bitrix /opt/.bx_temp && \
    chown -R bitrix:bitrix /opt/msmtp && \
    chown -R bitrix:bitrix /opt/browscap && \
    chown -R bitrix:bitrix /opt/geoip2 && \
    chown -R bitrix:bitrix /ssl

USER bitrix:bitrix
