
XXXX_SYM=${1}
XXXX_COIN=${2}
XXXX_RPCPORT=${3}
XXXX_P2PPORT=${4}
XXXX_company=${5}
FILES="Dockerfile app/encompass-mercury.conf app/start.sh etc/service/encompass-mercury/run etc/encompass-mercury.conf app/src/chains/XXXX_COIN.py"
for file in ${FILES} ; do
  sed -i -e 's/XXXX_SYM/'${XXXX_SYM}'/g' ${file}
  sed -i -e 's/XXXX_COIN/'${XXXX_COIN}'/g' ${file}
  sed -i -e 's/XXXX_RPCPORT/'${XXXX_RPCPORT}'/g' ${file}
  sed -i -e 's/XXXX_P2PPORT/'${XXXX_P2PPORT}'/g' ${file}
  sed -i -e 's/XXXX_company/'${XXXX_company}'/g' ${file}
done
