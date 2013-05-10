#!/bin/bash

#Ambari install script

wget http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA/ambari.repo
mv ambari.repo /etc/yum.repos.d/

yum install epel-release 
yum repolist
yum install ambari-server

ambari-server setup

ambari-server start




