#!/bin/bash

#--author:xinqiyang
#-- init weedfs to storage small file/image/audio 

p=$1
if [ "$p" = "" ]; then
   echo "Plear input project name!";
   exit
fi

#set storage

mkdir -p /weedfs/$p/volume1
mkdir -p /weedfs/$p/volume2
mkdir -p /weedfs/$p/volume3

#todo set permission
chmod -R 777 /weedfs/*
#chown www:www /weedfs/*




