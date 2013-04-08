#!/bin/bash

#if [ $1 -eq null ]; then 
#   echo "please input params1!"
#   exit
#fi

#if [ $2 -eq null ]; then 
#   echo "please input params2!"
#   exit
#fi



iplist=`cat machine.conf`

for ip in $iplist;do
   scp -r $1 root@$ip:$2
done



