FROM goacme/lego:v4.23.1

RUN addgroup -g 979 bitrix && \
    adduser -D -u 979 -G bitrix bitrix

RUN apk add --no-cache curl openssl bash mc ca-certificates tzdata && \
    mkdir -p /ssl && \
    chown -R bitrix:bitrix /ssl

#VOLUME ["/ssl"]

USER bitrix:bitrix

ENTRYPOINT [""]

CMD ["tail", "-f", "/dev/null"]
