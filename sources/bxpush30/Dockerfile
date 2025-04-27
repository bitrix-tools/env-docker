FROM node:20 AS builder

USER root

ENV PUSH=push-server.tar.gz

RUN mkdir -p /opt/push-server

COPY push-server-0.4.0.tar.gz /opt/push-server/$PUSH

WORKDIR /opt/push-server

RUN tar xzvvf $PUSH && rm -f $PUSH

RUN npm install --omit=dev

FROM node:20-alpine AS production

USER root

RUN apk --no-cache add shadow bash gettext libintl curl openssl ca-certificates tzdata && \
    addgroup -g 979 bitrix && \
    adduser -D -u 979 -G bitrix bitrix && \
    mkdir -p /usr/local/bin && \
    mv /usr/bin/envsubst /usr/local/bin/envsubst && \
    [[ ! -d /tmp/push-server ]] && mkdir /tmp/push-server && \
    [[ ! -d /etc/push-server ]] && mkdir /etc/push-server && \
    mkdir -p /var/log/push-server

WORKDIR /opt/push-server

COPY --from=builder /opt/push-server /opt/push-server
COPY docker-entrypoint.sh /usr/local/bin/
COPY push-server-pub.json /etc/push-server/push-server-pub.json
COPY push-server-sub.json /etc/push-server/push-server-sub.json

RUN chown -R bitrix:bitrix /opt/push-server && \
    chown -R bitrix:bitrix /tmp/push-server && \
    chown -R bitrix:bitrix /etc/push-server && \
    chmod 0755 /usr/local/bin/docker-entrypoint.sh && \
    chown -R bitrix:bitrix /var/log/push-server

# VOLUME /var/log/push-server

USER bitrix:bitrix

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
