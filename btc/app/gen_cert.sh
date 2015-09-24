#!/bin/bash -x

source /app/encompass-mercury.env
test -z ${COIN_SYM} && exit 1
cd /app/certs
mkdir gen_cert
cd gen_cert

openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
#writing RSA key
rm server.pass.key
openssl req -new -key server.key -out server.csr
#...
#Country Name (2 letter code) [AU]:US
#State or Province Name (full name) [Some-State]:California
#Common Name (eg, YOUR name) []: electrum-server.tld
#...
#A challenge password []:
#...
#
openssl x509 -req -days 730 -in server.csr -signkey server.key -out server.crt
mv server.key /app/certs/encompass-mercury-${COIN_SYM}.key
mv server.crt /app/certs/encompass-mercury-${COIN_SYM}.crt
cd ..
rm -rf gen_certs

