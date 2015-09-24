#!/bin/bash
dev="-dev"
COIN_SYM=${COIN_SYM:-btc}
IMAGE=${IMAGE:-mazaclub/encompass-mercury:${COIN_SYM}${dev}}
HOST_DATA_PREFIX=${HOST_DATA_PREFIX:-/opt/tmp/mercury/${COIN_SYM}/mercury-disk/}


docker run -it --rm \
  --name mercury_gencert \
  -e COIN=${COIN} \
  -e COIN_SYM=${COIN_SYM} \
  -v ${HOST_DATA_PREFIX}/app/certs:/app/certs \
  ${IMAGE} /app/gen_cert.sh
