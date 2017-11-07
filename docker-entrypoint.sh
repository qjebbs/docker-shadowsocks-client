#!/bin/bash

if [ ! $OBFS_ARG ]; then
    echo >&2 "Shadowsocks start without simple obfs..."
    ss-local -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -l $LOCAL_PORT \
              -b $LOCAL_ADDR \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT \
              $ARGS
else
    echo >&2 "Shadowsocks start with simple obfs ($OBFS_ARG)..."
    ss-local -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -l $LOCAL_PORT \
              -b $LOCAL_ADDR \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT \
              --plugin obfs-local \
              --plugin-opts "$OBFS_ARG" \
              $ARGS
fi