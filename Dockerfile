FROM debian:buster

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# Apt
RUN cp /etc/apt/sources.list /etc/apt/sources.list~ \
  && sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y wget make devscripts build-essential curl automake autoconf expect sudo apt-utils reprepro apt-transport-https jq zip dh-make \
  && wget https://dpkg.jc21.com/DPKG-GPG-KEY -O /tmp/jc21-dpkg-key \
  && apt-key add /tmp/jc21-dpkg-key \
  && echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list

RUN apt-get update \
  && apt-get install -y git \
  && apt-get -t buster-backports install -y debhelper \
  && apt-get clean

# Remove requiretty from sudoers main file
RUN sed -i '/Defaults    requiretty/c\#Defaults    requiretty' /etc/sudoers

# Rpm User
RUN useradd -G sudo builder \
  && mkdir -p /home/builder \
  && chmod -R 777 /home/builder

# Sudo
ADD etc/sudoers.d/builder /etc/sudoers.d/
RUN chown root:root /etc/sudoers.d/*

USER builder
WORKDIR /home/builder

