#!/bin/bash -x
#######
###### This provides a generic example to start an Encompass-Mercury server for a coin
IMAGE="mazaclub/encompass-mercury-start"
GROUP="encompass-mercury"
APP="encompass-mercury"
HOST_DATA_PREFIX="/opt/data/encompass-mercury"
MAZADIR="/home/maza/.${COIN}-v2"
DATA_VOLDIR="/var/encompass-mercury"
HOSTNAME="start.mercury.maza.club"
NAME="${GROUP}_${APP}"
#DATA=
#APPDATA=electrum-nmcdata
#DATADIR=/data/electrum-nmc-server
#PORT1="-p 50001:50003"
#PORT2="-p 50002:50004"
#PORT3="-p 8000:8000"

#check_data () {
# docker ps -a |grep ${GROUP}_${APPDATA} || docker run -d --name=${GROUP}_${APPDATA} -v ${DATA_VOLDIR}  ${DATA}
#

run () {
#check_data
docker run -d \
  -h "${HOSTNAME}" \
  --name=${NAME} \
  --restart=always \
  -p 50002:50002 \
  -p 8000:8000 \
  -p 9347:9347 \
  -v ${HOST_DATA_PREFIX}/${COIN}:${COINDIR}
  -v ${HOST_DATA_PREFIX}/encompass-mercury:${DATA_VOLDIR}
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
