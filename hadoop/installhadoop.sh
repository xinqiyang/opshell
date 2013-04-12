#!/bin/bash

#please prepare hadoop user 

#change to hadoop user
#su hadoop
#create id_rsa.pub 
#ssh-keygen -t rsa -P ""

#change to root
#su root

user=hadoop
iplist=`cat machine.conf`

jdk=jdk-6u32-linux-x64.bin
hadoop=hadoop-1.0.4.tar.gz
hbase=hbase-0.94.6.tar.gz
opshell=opshell
packageBase=/home/hadoop
packagePath=/home/hadoop/cdh4



#get ip list 
for ip in $iplist;do
	echo "=======now install $ip ==========="	
	#create user
	#ssh $user@$ip "useradd hadoop"
	#ssh $user@$ip "passwd hadoop"
	
	#move all danger
	ssh $user@$ip "rm -rf $packageBase/*"

	#get package
	ssh $user@$ip "mkdir -p $packageBase/.ssh/"
	cat id_rsa.pub | ssh $user@$ip "cat >> $packageBase/.ssh/authorized_keys"
	#set chmod 700  
	ssh $user@$ip "chmod 700 $packageBase/.ssh/authorized_keys"

	
	#copy package files
	ssh $user@$ip "mkdir -p $packagePath"
	ssh $user@$ip "chmod -R 777 $packagePath"
	
	scp -r $packagePath/$jdk $user@$ip:$packagePath
	scp -r $packagePath/$hadoop $user@$ip:$packagePath
	scp -r $packagePath/$hbase $user@$ip:$packagePath
	scp -r $packagePath/$opshell $user@$ip:$packagePath


	#unpacket 
	#unpacket jdk
	ssh $user@$ip "cd $packagePath;$packagePath/$jdk"
	ssh $user@$ip "ln -s $packagePath/jdk1.6.0_32 /home/hadoop/java"
	#unpacket hadoop
	ssh $user@$ip "tar zxvf $packagePath/$hadoop -C $packagePath"
	ssh $user@$ip "ln -s $packagePath/hadoop-1.0.4 $packageBase/hadoop"

	#unpacket hbase
	ssh $user@$ip "tar zxvf $packagePath/$hbase -C $packagePath"
	ssh $user@$ip "ln -s $packagePath/hbase-0.94.6 $packageBase/hbase"

	#create storepackage
	ssh $user@$ip "mkdir -p $packageBase/hadoopdata"
	ssh $user@$ip "chmod -R 777 $packageBase/hadoopdata"
	
	ssh $user@$ip "mkdir -p $packageBase/mapred"
	ssh $user@$ip "chmod -R 777 $packageBase/mapred"
	
	ssh $user@$ip "mkdir -p /tmp/hadoop/mapred/system"
	ssh $user@$ip "mkdir -p /tmp/zookeeper"
	ssh $user@$ip "mkdir -p /home/hadoop/hbase/tmp/zk"





	#run scripts
	ssh $user@$ip "sh $packagePath/opshell/sys/centos_init.sh"
	
	#set /etc/profile
	scp -r /etc/profile $user@$ip:/etc/profile

	#copy set to host 
	scp -r /etc/hosts $user@$ip:/etc/hosts
	
	#copy hadoop config 
	scp -r hadoopconf/* $user@$ip:$packageBase/hadoop/conf/
	#copy hbase config 
	scp -r hbaseconf/* $user@$ip:$packageBase/hbase/conf/

	echo "=================$ip install completely!==================================="
done







