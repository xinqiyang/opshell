#!/bin/bash

##################
# install haproxy
##################

groupadd -r haproxy
useradd -r -M -g haproxy -s /sbin/nologin haproxy
#wget http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.23.tar.gz
tar zxvf haproxy-1.4.23.tar.gz
cd haproxy-1.4.23
make TARGET=linux26 PREFIX=/usr/local/haproxy install
cd /usr/local/
chown -R haproxy. haproxy/
cd /usr/local/haproxy/

