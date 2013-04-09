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
iplist=`cat /home/hadoop/gitclone/opshell/hadoop/machine.conf`

for ip in $iplist;do
   echo "-----ops $ip -------------"
   if [ "$1" == "scp" ] ; then	
   	scp -r $2 $user@$ip:$3
   elif [ "$1" == "ssh" ] ; then
	cat ~/.ssh/id_rsa.pub | ssh $user@$ip "cat >> /home/hadoop/.ssh/authorized_keys"
	ssh $user@$ip "chmod 700 /home/hadoop/.ssh/authorized_keys"
   elif [ "$1" == "cmd" ] ; then
	ssh $user@$ip "$2"
   fi
done



