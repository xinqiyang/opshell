#!/bin/bash

##
## init weedfs
## nohup sh weedfs.sh freeflare app.test.com >/dev/null 2>1 &
##

p=$1
domain=$2
if [ "$p" = "" ]; then
   echo "Plear input project name!";
   exit
fi

if [ "$domain" = "" ]; then
   echo "Plear input domain name of project!";
   exit
fi

cd /source/$p/server/packages

./weed master >/logs/weedfs/$p/master.log 2>1 &
./weed volume -dir="/weedfs/$p/volume1" -max=5  -mserver="$domain:9333" -port=9331 &

#./weed volume -dir="/weedfs/$p/volume2" -max=10 -mserver="$domain:9333" -port=9332 & 



