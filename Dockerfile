FROM ubuntu:16.04

# build arguments, pass these to "docker build" by using --build-arg
ARG HYPERSH_ACCESS_KEY
ARG HYPERSH_SECRET
ARG HYPERSH_REGION

# TODO: setup squid with: https://github.com/sameersbn/docker-squid/blob/master/Dockerfile or https://github.com/jpetazzo/squid-in-a-can  (seems better-featured but runs in a separate container)
# (note: a proxy needs a certificate to use https, http://roberts.bplaced.net/index.php/linux-guides/centos-6-guides/proxy-server/squid-transparent-proxy-http-https)

RUN apt-get update
RUN apt-get install -y software-properties-common 
RUN add-apt-repository ppa:ubuntu-mozilla-daily/ppa
RUN apt-get update
RUN apt-get install -y python-software-properties tcpdump
RUN apt-get install -y python3-pip python3-dev firefox xvfb default-jre wget openssh-server

# install hyper.sh
RUN wget https://hyper-install.s3.amazonaws.com/hyper-linux-x86_64.tar.gz
RUN tar xzf hyper-linux-x86_64.tar.gz
RUN mv /hyper /usr/bin/hyper

# configure hyper.sh
ENV HYPERSH_ACCESS_KEY ${HYPERSH_ACCESS_KEY}
ENV HYPERSH_SECRET ${HYPERSH_SECRET}
ENV HYPERSH_REGION ${HYPERSH_REGION}
RUN hyper config --accesskey $HYPERSH_ACCESS_KEY --secretkey $HYPERSH_SECRET --default-region $HYPERSH_REGION

ADD ./install_gecko.sh /tmp/install_gecko.sh
RUN /bin/bash /tmp/install_gecko.sh
ENV PATH $PATH:/usr/local/lib
ENV SCREENSIZE 1920x1600x16
ENV DISPLAY :11
ENV PROXY_CONTAINER  # gets passed in when launching container

RUN pip3 install selenium pyvirtualdisplay

RUN wget http://selenium-release.storage.googleapis.com/3.6/selenium-server-standalone-3.6.0.jar

ADD ./start.sh /tmp/start.sh
ENTRYPOINT ["/bin/bash", "/tmp/start.sh"]
