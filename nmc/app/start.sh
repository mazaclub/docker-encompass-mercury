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
RPCPORT=${RPCPORT:-8336}
RPCUSER=${RPCUSER:-$(grep rpcuser "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
RPCPASSWORD=${RPCPASSWORD:-$(grep rpcpassword "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
txidx=$(grep "txindex=" "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')
TXINDEX=${TXINDEX:-${txidx}}
ENCOMPASS_MERCURY_PASSWORD=$(egrep '^password =' /etc/encompass-mercury.conf|awk -F= '{print $2}')
ENCOMPASS_MERCURY_IRCNICK=${ENCOMPASS_MERCURY_IRCNICK:-${COIN}_mazaclub}


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
	encompass-mercury.conf > /tmp/new-encompass-mercury.conf
cp /tmp/new-encompass-mercury.conf /etc/encompass-mercury.conf
exec /app/run_encompass_mercury --coin ${COIN_SYM}
	#-e 's/^password\ \=.*/password\ \=\ '${ENCOMPASS_MERCURY_PASSWORD}'/g' \
