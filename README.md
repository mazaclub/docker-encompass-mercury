# docker-encompass-mercury
Docker images for Encompass-Mercury for several coins - 1 coin per branch

All images include coind and Encompass-Mercury configure for that coin.

Allow for significant initial startup time. Encompass-Mercury its parent Electrum-server
take significant time to build the initial Database 


Docker images are available as automated builds on Dockerhub
There is no "latest" tag, all builds are tagged by coin symbol
 mazaclub/encompass-mercury:{COIN}
'''
docker pull mazaclub/encompass-mercury:dash
'''
Images are built FROM
phusion/baseimage
mazaclub/coind-base
mazaclub/{COIN}d-base

Pull Requests with additional coins always welcomed!! 

Automated builds are currently available for:
 - START - Startcoin
 - DASH  - Dashpay

# Usage
CoreOS Unit files are provided, as is example shellscript.

A Typical run to build the initial DB
```
docker run  --name encompass-mercury_start   \
  -v /mnt/tmp/encompass-mercury-start/var/encompass-mercury:/var/encompass-mercury  \
  -v /mnt/tmp/encompass-mercury-start/home/coin:/home/coin  \
  -v /mnt/tmp/encompass-mercury-start/app/certs:/app/certs  \
  -p 50001:50001   -p 50002:50002   -p 8000:8000   \
  -e TXINDEX=1  \
  -e ENCOMPASS_MERCURY_HOSTNAME=start.mercury.mazaclub  \
  -e HOSTNAME=start.mercury.mazaclub  \
  -e COIND=localhost  \
  -e RPCPORT=9347  \
  -e P2PORT=9247  \
  -h start.mercury.mazaclub   \
  mazaclub/encompass-mercury:start
```
 - The initial database "forging" can take a long time. If you do not already have a
copy of the desired blockchain data, txindexed, you will need to allow additional time for this as well.
 - Time to forge depends on the chain, block interval, transactions per block, and your hardware. This can range from a few hours, to more than a day for some coins, on some hardware.
 - Image may not start encompass-mercury correctly on initial forge. Workaround:
   ```
   docker-enter [container-id]
   mv /etc/service/encompass-mercury /tmp
   ```
   Wait until all blocks are fully downloaded, 
   ```
   mv /tmp/encompass-mercury /etc/service
   ```
   

