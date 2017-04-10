#
# Ubuntu 14.04
#
# https://hub.docker.com/_/ubuntu/
#

# Pull base image.
FROM uwitech/ohie-base

USER root

#install tools

RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get -y install nodejs
RUN apt-get -y install git build-essential
RUN apt-get -y install software-properties-common python-software-properties openjdk-7-jdk unzip
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org-shell


#install openhim

RUN npm -y install -g openhim-core
RUN mkdir /etc/openhim

COPY default.json /etc/openhim/core.json
COPY mongo.js /etc/openhim/mongo.js

#install mediators

COPY InstallCert.java.zip /root/InstallCert.java.zip

COPY mediators.sh /root/mediators.sh
RUN chmod 777 /root/mediators.sh
RUN /root/mediators.sh

COPY mediator.properties /root/mediator.properties

COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh

EXPOSE 8080
