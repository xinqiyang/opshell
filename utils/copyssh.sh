#!/bin/bash

#copy id_rsa.pub to target machine

if [$1 -eq null]; then 
   echo "please user!"
   exit
fi

if [$2 -eq null]; then 
   echo "please input machine ip address!"
   exit
fi




cat ~/.ssh/id_rsa.pub | ssh $1@$2 "cat >> ~/.ssh/authorized_keys"

