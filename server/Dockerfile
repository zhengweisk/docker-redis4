FROM debian:stretch-slim

ADD rootfs.tar.gz /

RUN set -x \
 && groupadd -r redis && useradd -r -g redis redis \
 && mkdir -p /data \
 && chown redis:redis /data

VOLUME /data

WORKDIR /data

EXPOSE 6379

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "redis-server" ]

