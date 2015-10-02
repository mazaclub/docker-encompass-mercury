#!/bin/bash

# Mazacoind is expected to be at hostname 'namecoind'
# which is set via --link
# Because we use linked containers we can use the 
# standard ports 
### Tate-server doesn't really support testnet
. /app/encompass-mercury.env
USER=${USER:-coin}
ENCOMPASS_MERCURY_HOSTNAME=${ENCOMPASS_MERCURY_HOSTNAME:-${HOSTNAME}}
ENCOMPASS_MERCURY_PORT=${ENCOMPASS_MERCURY_PORT:-50001}
ENCOMPASS_MERCURY_SSLPORT=${ENCOMPASS_MERCURY_SSL_PORT:-50002}
COIND=${COIND:-localhost}
COINDIR=${COINDIR:-/home/${USER}/.${COIN}}
RPCPORT=${RPCPORT:-8888}
RPCUSER=${RPCUSER:-$(grep rpcuser "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
RPCPASSWORD=${RPCPASSWORD:-$(grep rpcpassword "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
txidx=$(grep "txindex=" "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')
TXINDEX=${TXINDEX:-${txidx}}
ENCOMPASS_MERCURY_PASSWORD=$(egrep '^password =' /etc/encompass-mercury.conf|awk -F= '{print $2}')
ENCOMPASS_MERCURY_IRCNICK=${ENCOMPASS_MERCURY_IRCNICK:-$[ 1 + $[RANDOM % 99999 ]]__mazaclub}
ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE=${ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE:-120}
ENCOMPASS_MERCURY_PRUNING_LIMIT=${ENCOMPASS_MERCURY_PRUNING_LIMIT:-10000}
ENCOMPASS_MERCURY_DONATION_ADDR=${ENCOMPASS_MERCURY_DONATION_ADDR:-MPXEVRtXTBrz6xfn9iCyzK7Kr8P69oZjyq}
ENCOMPASS_MERCURY_REPORT_HOST=${ENCOMPASS_MERCURY_REPORT_HOST:-${ENCOMPASS_MERCURY_HOSTNAME}}
ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT=${ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT:-${ENCOMPASS_MERCURY_TCP_PORT}}
ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT=${ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT:-${ENCOMPASS_MERCURY_SSL_PORT}}
ENCOMPASS_MERCURY_CERT_FILE=${ENCOMPASS_MERCURY_CERT_FILE:-/app/certs/encompass-mercury-${COIN_SYM}.crt}
ENCOMPASS_MERCURY_KEY_FILE=${ENCOMPASS_MERCURY_KEY_FILE:-/app/certs/encompass-mercury-${COIN_SYM}.key}


if [ ! -f ${ENCOMPASS_MERCURY_KEY_FILE}  ] ; then
   echo "${ENCOMPASS_MERCURY_KEY_FILE} not found"
   echo "Refusing to start with out a cert key"
   echo "Make a new key with /app/gen_cert.sh"
   echo "If this server was in operation and you regenerate your certificat"
   echo "clients will refuse to connect via SSL unless the remove old cert info"
   echo "To temporarily stop the encompass-mercury service:"
   echo "touch /etc/service/encompass-mercury/down"
   echo "Either shut down this container and run the host-level shell script"
   echo "to run this image and create a cert for normal operation of this image"
   echo "or run /app/gen_cert.sh directly - ensure that you've mapped /app/certs"
   echo "correctly so that you can save your new certificate."
   exit 55
fi
if [ ! -f ${ENCOMPASS_MERCURY_CERT_FILE} ] ; then
      echo "Don't see your crt as .crt or .pem file in /app/certs"
      echo "If this server was in operation and you regenerate your certificat"
      echo "clients will refuse to connect via SSL unless the remove old cert info"
      touch /etc/service/encompass-mercury/down
      echo "Either shut down this container and run the host-level shell script"
      echo "to run this image and create a cert for normal operation of this image"
      echo "or run /app/gen_cert.sh directly - ensure that you've mapped /app/certs"
      echo "correctly so that you can save your new certificate."
      exit 54
fi
cert_host=$( openssl x509 -in ${ENCOMPASS_MERCURY_CERT_FILE} -text -noout |grep Subject |grep CN|awk 'BEGIN{FS="/|=|,"; OFS="\t"}{print $12}')
if [ "${cert_host}" != "${ENCOMPASS_MERCURY_REPORT_HOST}" ] ; then
   echo "Your externl name and your SSL certificate don't match"
      echo "If this server was in operation and you regenerate your certificat"
      echo "clients will refuse to connect via SSL unless the remove old cert info"
      touch /etc/service/encompass-mercury/down
      echo "Either shut down this container and run the host-level shell script"
      echo "to run this image and create a cert for normal operation of this image"
      echo "or run /app/gen_cert.sh directly - ensure that you've mapped /app/certs"
      echo "correctly so that you can save your new certificate."
      exit 50
fi
 

test -z $ENCOMPASS_MERCURY_PASSWORD && ENCOMPASS_MERCURY_PASSWORD=$(apg -a 0 -m 32 -x 32 -n 1)
if [ "${TXINDEX}" = "1" ] ; then
   echo "-txindex is set    good to go"
else echo "$(date) txindex not set in ${COIN}.conf - daemon restart required"
     touch /etc/service/${COIN}d/down
     echo "Now you can start ${COIN}d manually with -reindex and then add:"
     echo "txindex=1"
     echo "to your ${COINDIR}/${COIN}.conf"
     echo "then remove /etc/service/${COIN}d/down"
fi     
## this is kinda backwards, but there you have it
echo "$(date) starting Encompass-Mercury with RPC for ${COIN} from: ${COIND}:${RPCPORT}"
cd /app
IFS="" sed -e 's/coind_host\ \=.*/coind_host\ \=\ '${COIND}'/g' \
	-e 's/coind_port\ \=.*/coind_port\ \=\ '${RPCPORT}'/g' \
	-e 's/coind_user\ \=.*/coind_user\ \=\ '${RPCUSER}'/g' \
	-e 's/coind_password\ \=.*/coind_password\ \=\ '${RPCPASSWORD}'/g' \
	-e 's/^host\ \=.*/host\ \=\ '${ENCOMPASS_MERCURY_HOSTNAME}'/g' \
	-e 's/^username\ \=.*/username\ \=\ '${USER}'/g' \
	-e 's/^stratum_tcp_ssl_port\ \=.*/stratum_tcp_ssl_port\ \=\ '${ENCOMPASS_MERCURY_SSLPORT}'/g' \
	-e 's/^stratum_tcp_port\ \=.*/stratum_tcp_port\ \=\ '${ENCOMPASS_MERCURY_PORT}'/g' \
        -e 's/^irc_nick\ \=.*/irc_nick\ \=\ '${ENCOMPASS_MERCURY_IRCNICK}'/g' \
        -e 's/^pruning_limit\ \=.*/pruning_limit\ \=\ '${ENCOMPASS_MERCURY_PRUNING_LIMIT}'/g' \
        -e 's/^block_cache_size\ \=.*/block_cache_size\ \=\ '${ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE}'/g' \
        -e 's/^report_stratum_tcp_ssl_port\ \=.*/report_stratum_tcp_ssl_port\ \=\ '${ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT}'/g' \
        -e 's/^report_stratum_tcp_port\ \=.*/report_stratum_tcp_port\ \=\ '${ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT}'/g' \
        -e 's/^report_host\ \=.*/report_host\ \=\ '${ENCOMPASS_MERCURY_REPORT_HOST}'/g' \
        -e 's|^ssl_certfile\ \=.*|ssl_certfile\ \=\ '${ENCOMPASS_MERCURY_CERT_FILE}'|g' \
        -e 's|^ssl_keyfile\ \=.*|ssl_keyfile\ \=\ '${ENCOMPASS_MERCURY_KEY_FILE}'|g' \
        encompass-mercury.conf > /tmp/new-encompass-mercury.conf
cp /tmp/new-encompass-mercury.conf /etc/encompass-mercury.conf
shopt -s nocasematch
if [[ "${ENCOMPASS_MERCURY_IRC_OVERRIDE}" = "true" ]]; then
  test -z ${ENCOMPASS_MERCURY_IRC_CHANNEL} \
   || sed -e 's/^irc_channel\ \=.*/irc_channel\ \=\ '${ENCOMPASS_MERCURY_IRC_CHANNEL}'/g' \
           /app/src/chains/${COIN}.py > /tmp/new_${COIN}.py
           mv /tmp/new_${COIN}.py /app/src/chains/${COIN}.py
  test -z ${ENCOMPASS_MERCURY_IRCNICK_PREFIX} \
   || sed -e 's/^irc_nick_prefix\ \=.*/irc_nick_prefix\ \=\ '${ENCOMPASS_MERCURY_IRCNICK_PREFIX}'/g' \
           /app/src/chains/${COIN}.py > /tmp/new_${COIN}.py
           mv /tmp/new_${COIN}.py /app/src/chains/${COIN}.py
shopt -u nocasematch
fi
exec /app/run_encompass_mercury --coin ${COIN_SYM}

