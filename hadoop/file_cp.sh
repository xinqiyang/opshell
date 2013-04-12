#!/bin/bash

#if [ $1 -eq null ]; then 
#   echo "please input params1!"
#   exit
#fi

#if [ $2 -eq null ]; then 
#   echo "please input params2!"
#   exit
#fi

# type , $1 { scp, ssh },  src $2, dst $3
user=hadoop

if [ "$3" != "" -a "$1" != "scp" ] ; then
    user=$3
fi

if [ "$4" != "" ] ; then 
	iplist=$4
else 
	iplist=`cat /home/hadoop/gitclone/opshell/hadoop/machine.conf` 
fi

for ip in $iplist;do
   echo "-----ops $ip -------------"
   if [ "$1" == "scp" ] ; then	
   	scp -r $2 $user@$ip:$3
   elif [ "$1" == "ssh" ] ; then
	ssh $user@$ip "mkdir ~/.ssh | touch ~/.ssh/authorized_keys"
	cat ~/.ssh/id_rsa.pub | ssh $user@$ip "cat >> ~/.ssh/authorized_keys"
	ssh $user@$ip "chmod 700 ~/.ssh"
   elif [ "$1" == "cmd" ] ; then
	ssh $user@$ip "$2"
   fi
done



