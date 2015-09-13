# docker-encompass-mercury
Docker images for Encompass-Mercury for several coins - 1 coin per branch

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


