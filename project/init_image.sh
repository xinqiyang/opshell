#!/bin/bash

#--author:xinqiyang
#-- init images


p=$1
if [ "$p" = "" ]; then
   echo "Plear input project name!";
   exit
fi

#set images storage
mkdir -p /images/$p
mkdir -p /images/$p/origin
mkdir -p /images/$p/500
mkdir -p /images/$p/400
mkdir -p /images/$p/160
mkdir -p /images/$p/100
mkdir -p /images/$p/48
mkdir -p /images/$p/24

#todo set permission
chmod -R 777 /images/*
#chown www:www /images/*



	