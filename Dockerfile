#
# Dockerfile for shadowsocks-client
#

FROM alpine

ARG SS_VER=3.1.0
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz

ARG SIMPLE_OBFS_VER=0.0.4
ARG SIMPLE_OBFS_URL=https://github.com/shadowsocks/simple-obfs.git
ARG SIMPLE_OBFS_DIR=simple-obfs

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV LOCAL_ADDR  0.0.0.0
ENV LOCAL_PORT  1080
ENV PASSWORD=
ENV METHOD      aes-256-cfb
ENV TIMEOUT     300
ENV OBFS_ARG=
ENV ARGS=

RUN set -ex && \
    apk update && \
    apk add --no-cache --virtual .build-deps \
                                autoconf \
                                build-base \
                                curl \
                                libev-dev \
                                libtool \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                tar \
                                automake \
                                gettext-dev \
                                openssl-dev \
                                git \
                                c-ares-dev && \
    cd /tmp && \
    curl -sSL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \
    git clone $SIMPLE_OBFS_URL && \
    cd $SIMPLE_OBFS_DIR && \
    git checkout master && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --disable-documentation && \
    make install && \
    cd .. && \
    rm -rf $SIMPLE_OBFS_DIR && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/*

USER nobody

EXPOSE $LOCAL_PORT/tcp

COPY docker-entrypoint.sh /

ENTRYPOINT sh /docker-entrypoint.sh
