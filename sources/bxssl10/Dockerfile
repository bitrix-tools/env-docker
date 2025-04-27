FROM alpine:3.21

RUN addgroup -g 979 bitrix && \
    adduser -D -u 979 -G bitrix bitrix

RUN apk add --no-cache curl openssl bash mc ca-certificates tzdata && \
    mkdir -pv /opt /ssl

COPY cas.sh /opt/cas.sh
COPY srv.sh /opt/srv.sh
COPY dhparam.pem /ssl/dhparam.pem

RUN chown -R bitrix:bitrix /ssl && \
    chown -R bitrix:bitrix /opt && \
    ln -s /opt/cas.sh /home/bitrix && \
    ln -s /opt/srv.sh /home/bitrix

#VOLUME ["/ssl"]

USER bitrix:bitrix

CMD ["tail", "-f", "/dev/null"]
