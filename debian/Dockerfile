FROM buildpack-deps:stretch

COPY *.sh /root/

WORKDIR /root

RUN set -x \
 && apt-get update && apt-get install -y --no-install-recommends tcl \
 && rm -rf /var/lib/apt/lists/* \
 && export REDIS_VER=4.0.2 \
 && export REDIS_TAR=redis-${REDIS_VER}.tar.gz \
 && curl -fsSLO http://download.redis.io/releases/${REDIS_TAR} \
 && tar -xzf ${REDIS_TAR} \
 && cd redis-${REDIS_VER} \
 && make \
 && make test \
 && cd .. \
 && curl -fsSLO https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 \
 && chmod +x gosu-amd64 \
 && chmod +x docker-entrypoint.sh \
 && mkdir -p rootfs \
 && cd rootfs \
 && cp ../redis-${REDIS_VER}/src/redis-server . \
 && cp ../redis-${REDIS_VER}/src/redis-cli . \
 && mv ../gosu-amd64 ./gosu \
 && mv ../docker-entrypoint.sh .


FROM debian:stretch

COPY --from=0 /root/rootfs /root

RUN set -x \
 && groupadd -r redis && useradd -r -g redis redis \
 && cd /root \
 && mv docker-entrypoint.sh / \
 && mv gosu /usr/local/bin/ \
 && mv redis-server /usr/local/bin/ \
 && mv redis-cli /usr/local/bin/ \
 && mkdir -p /data \
 && chown redis:redis /data

VOLUME /data

WORKDIR /data

EXPOSE 6379

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "redis-server" ]

