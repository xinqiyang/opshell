#!/bin/bash

#--author:xinqiyang
#-- init log

#project name


p=$1
if [ "$p" = "" ]; then
   echo "Plear input project name!";
   exit
fi

mkdir -p /logs/php/$p/web
mkdir -p /logs/php/$p/api
mkdir -p /logs/php/$p/mis
mkdir -p /logs/php/$p/wap
mkdir -p /logs/php/$p/img
mkdir -p /logs/php/$p/dev
mkdir -p /logs/php/$p/blog
mkdir -p /logs/php/$p/crm


mkdir -p /logs/nginx/$p/web
mkdir -p /logs/nginx/$p/api
mkdir -p /logs/nginx/$p/mis
mkdir -p /logs/nginx/$p/wap
mkdir -p /logs/nginx/$p/img
mkdir -p /logs/nginx/$p/dev
mkdir -p /logs/nginx/$p/blog
mkdir -p /logs/nginx/$p/crm
mkdir -p /logs/nginx/$p/res


chmod -R 777 /logs/*

echo "Create $p's log path OK!";










