#!/bin/bash -x
###### This provides a generic example to start an Encompass-Mercury server for a coin
# Variables are given with defaults! 
# Either set variables on command line overriding default in this script:
#     USER=coin ENCOMPASS_MERCURY_IRCNICK=mazaclub ./start_Encompass-Mercury.sh 
# OR
# change the default in this script
#     ENCOMPASS_MERCURY_IRCNICK=${ENCOMPASS_MERCURY_IRCNICK:-mazaclub}}
#     ->>  ENCOMPASS_MERCURY_IRCNICK=${ENCOMPASS_MERCURY_IRCNICK:-metalurgist}}
#     OR   ENCOMPASS_MERCURY_IRCNICK=metalurgist
#
# 

###########################
### Variables supported by mazaclub/${COIND}-base images
###  - these are used INSIDE the docker container, 
###    and provided to it via -e ENV=var in docker run statements
###  - these variables are required to be set
###  - TXINDEX=1 is required for Encompass-Mercury operation
###  - it is HIGHLY recommended to NOT REINDEX your blockchain 
###    and instead download a fresh copy with TXINDEX=1 set

COIN=${COIN:-bitcoin}
COIN_SYM=${COIN_SYM:-mzc}
COIND=${COIND:-localhost}
RPCPORT=${RPCPORT:-8332}
COINDIR=${COINDIR:-/home/${USER}/.${COIN}}
TXINDEX=${TXINDEX:-1}

###############################################
## Variables for start_Encompass-Mercury.sh 
##  - these are NOT used inside the container, these are 
##    only used to START the container

IMAGE="${IMAGE:-mazaclub/encompass-mercury:${COIN_SYM}}"
GROUP="mercury"
APP="${COIN}"
HOST_DATA_PREFIX="/opt/data/encompass-mercury"
DATA_VOLDIR="/var/encompass-mercury/${COIN_SYM}"
HOSTNAME="${COIN_SYM}.mercury.${DOMAIN}"
NAME="${GROUP}_${APP}"
#################################

#################################
## Variables supported in /app/start.sh
###  - these are used INSIDE the docker container, 
###    and provided to it via -e ENV=var in docker run statements
###  - thes show their default values in /app/start.sh
###  - used to configure encompass-mercury.conf
###  - If you are behind NAT, and are connecting your server to IRC
###    ENCOMPASS_MERCURY_REPORT_HOST
###    ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT
###    ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT
###    are needed to provide IRC clients with your correct public DNS/ports

#ENCOMPASS_MERCURY_PRUNING_LIMIT=${ENCOMPASS_MERCURY_PRUNING_LIMIT:-10000}
#ENCOMPASS_MERCURY_HOSTNAME=${ENCOMPASS_MERCURY_HOSTNAME:-${HOSTNAME}}
#ENCOMPASS_MERCURY_PORT=${ENCOMPASS_MERCURY_PORT:-50001}
#ENCOMPASS_MERCURY_SSLPORT=${ENCOMPASS_MERCURY_SSL_PORT:-50002}
#RPCUSER=${RPCUSER:-$(grep rpcuser "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
#RPCPASSWORD=${RPCPASSWORD:-$(grep rpcpassword "${COINDIR}"/${COIN}.conf |awk -F= '{print $2}')}
#ENCOMPASS_MERCURY_PASSWORD=$(egrep '^password =' /etc/encompass-mercury.conf|awk -F= '{print $2}')
#ENCOMPASS_MERCURY_IRCNICK=${ENCOMPASS_MERCURY_IRCNICK:-$[ 1 + $[RANDOM % 99999 ]]__mazaclub}
#ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE=${ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE:-120}
#ENCOMPASS_MERCURY_DONATION_ADDR=${ENCOMPASS_MERCURY_DONATION_ADDR:-1CnCRnTLW1uQaFWguRsvmQJXWA3G9nfa9T}
#ENCOMPASS_MERCURY_REPORT_HOST=${ENCMPASS_MERCURY_REPORT_HOST:-${ENCOMPASS_MERCURY_HOSTNAME}}
#ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT=${ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT:-${ENCOMPASS_MERCURY_PORT}}
#ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT=${ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT:-${ENCOMPASS_MERCURY_SSL_PORT}}
#######################################



ENCOMPASS_MERCURY_PRUNING_LIMIT=${ENCOMPASS_MERCURY_PRUNING_LIMIT:-10000}
ENCOMPASS_MERCURY_HOSTNAME=${ENCOMPASS_MERCURY_HOSTNAME:-mzc.mercury.docker.local}
ENCOMPASS_MERCURY_PORT=${ENCOMPASS_MERCURY_PORT:-50001}
ENCOMPASS_MERCURY_SSL_PORT=${ENCOMPASS_MERCURY_SSL_PORT:-50002}
ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT=${ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT:-50001}
ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT=${ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT:-50002}
ENCOMPASS_MERCURY_IRCNICK=${ENCOMPASS_MERCURY_IRCNICK:-dev_mazaclub}
ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE=${ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE:-120}
ENCOMPASS_MERCURY_DONATION_ADDR=${ENCOMPASS_MERCURY_DONATION_ADDR:-1CnCRnTLW1uQaFWguRsvmQJXWA3G9nfa9T}
ENCOMPASS_MERCURY_REPORT_HOST=${ENCMPASS_MERCURY_REPORT_HOST:-mzc.mercury.maza.club}



run () {
docker run -d \
  -h "${HOSTNAME}" \
  --name=${NAME} \
  --restart=always \
  -p ${ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT}:${ENCOMPASS_MERCURY_SSL_PORT} \
  -p ${ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT}:${ENCOMPASS_MERCURY_PORT} \
  -p ${ENCOMPASS_MERCURY_OUTSIDE_DAEMON_PORT}:${ENCOMPASS_MERCURY_DAEMON_PORT} \
  -p ${OUTSIDE_RPCPORT}:${RPCPORT} \
  -v ${HOST_DATA_PREFIX}/${COIN}:${COINDIR} \
  -v ${HOST_DATA_PREFIX}/encompass-mercury:${DATA_VOLDIR} \
  -v ${HOST_DATA_PREFIX}/log:/var/log/encompass-mercury-${COIN}.log \
  -e COIN=${COIN} \
  -e COIN_SYM=${COIN_SYM} \
  -e COIND=${COIND} \
  -e RPCPORT=${RPCPORT} \
  -e COINDIR=${COINDIR} \
  -e TXINDEX=${TXINDEX} \
  -e ENCOMPASS_MERCURY_PRUNING_LIMIT=${ENCOMPASS_MERCURY_PRUNING_LIMIT} \
  -e ENCOMPASS_MERCURY_HOSTNAME=${ENCOMPASS_MERCURY_HOSTNAME} \
  -e ENCOMPASS_MERCURY_PORT=${ENCOMPASS_MERCURY_PORT} \
  -e ENCOMPASS_MERCURY_SSL_PORT=${ENCOMPASS_MERCURY_SSL_PORT} \
  -e ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT=${ENCOMPASS_MERCURY_OUTSIDE_TCP_PORT} \
  -e ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT=${ENCOMPASS_MERCURY_OUTSIDE_SSL_PORT} \
  -e ENCOMPASS_MERCURY_IRCNICK=${ENCOMPASS_MERCURY_IRCNICK} \
  -e ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE=${ENCOMPASS_MERCURY_BLOCK_CACHE_SIZE} \
  -e ENCOMPASS_MERCURY_DONATION_ADDR=${ENCOMPASS_MERCURY_DONATION_ADDR} \
  -e ENCOMPASS_MERCURY_REPORT_HOST=${ENCMPASS_MERCURY_REPORT_HOST} \
  ${IMAGE}

}

start () {
docker start ${NAME}
}
stop () {
docker stop ${NAME}
}

remove () {
docker rm ${NAME}
}


case ${1} in
 remove) remove
	;;
  start) start
	;;
   stop) stop
	;;
    run) run
	;;
      *) echo "Usage: ${0} [run|start|stop|remove]"
	;;
esac
