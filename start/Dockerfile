FROM		mazaclub/startcoind-base
# IMAGE mazaclub/encompass-mercury-start
MAINTAINER	Rob Nelson <guruvan@maza.club>

EXPOSE		50001 50002 8000
VOLUME		["/home/coin","/var/encompass-mercury"]
ENTRYPOINT	["/sbin/my_init"]
ENV		COIND localhost

RUN		apt-get update \
		  && apt-get install -y \
		    apg python-dev python2.7 python-pip \
		    git libleveldb1 libleveldb-dev 

RUN		echo "bitcoin hard nofile 65536" >> /etc/security/limits.conf \
     		  && echo "bitcoin soft nofile 65536" >> /etc/security/limits.conf \
		  && cd / \
		  && git clone https://github.com/mazaclub/encompass-mercury \
		  && cd /encompass-mercury \
		  && python setup.py install \
                  && mkdir -pv /app \
                  && mv /encompass-mercury/* /app \
		  && rm -rf /etc/service/sshd

ADD		. /
RUN		chmod +x /etc/service/encompass-mercury/run
