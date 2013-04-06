#!/bin/bash

#please prepare hadoop user 

#change to hadoop user
su hadoop
#create id_rsa.pub 
ssh-keygen -t rsa -P ""

#change to root
su root

user=root
iplist=`cat machine.conf`

jdk=jdk-6u32-linux-x64.bin
hadoop=hadoop-1.0.4.tar.gz
hbase=hbase-0.94.6.tar.gz

packageBase=/home/hadoop
packagePath=/home/hadoop/packages



#get ip list 
for ip in $iplist;do
	
	#create user
	ssh $user@$ip "useradd hadoop"
	ssh $user@$ip "passwd hadoop"

	#get package
	ssh $user@$ip "mkdir -p $packageBase/.ssh/"
	cat $packageBase/.ssh/id_rsa.pub | ssh $user@$ip "cat >> $packageBase/.ssh/authorized_keys"
	#set chmod 700  
	ssh $user@$ip "chmod 700 $packageBase/.ssh/authorized_keys"
	

	#copy package files
	echo "scp -r $packagePath $user@$ip:$packagePath"

	scp -r $packagePath $user@$ip:$packagePath
	
	
	#unpacket 
	#unpacket jdk
	ssh $user@$ip "$packagePath/$jdk"
	#unpacket hadoop
	ssh $user@$ip "tar zxvf $packagePath/$hadoop"
	ssh $user@$ip "ln -s $packagePath/hadoop-1.0.4 $packageBase/hadoop"

	#unpacket hbase
	ssh $user@$ip "tar zxvf $packagePath/$hbase"
	ssh $user@$ip "ln -s $packagePath/hbase-0.94.6 $packageBase/hbase"

	#create storepackage
	ssh $user@$ip "mkdir -p $packageBase/hadoopdata"
	ssh $user@$ip "chmod -R 777 $packageBase/hadoopdata"

	#run scripts
	ssh $user@$ip "sh $packagePath/opshell/sys/centos_init.sh"
	
	#set /etc/profile

	ssh $user@$ip " echo \"export JAVA_HOME=/home/hadoop/packages/jdk1.6.0_32/\" >> /etc/profile"
	ssh $user@$ip " echo \"export JRE_HOME=/home/hadoop/packages/jdk1.6.0_32/jre\" >> /etc/profile"
	ssh $user@$ip " echo \"export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib\" >> /etc/profile"
	ssh $user@$ip " echo \"export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin\" >> /etc/profile"

	ssh $user@$ip " echo \"export HADOOP_HOME=/home/hadoop/hadoop\" >> /etc/profile"
	ssh $user@$ip " echo \"export PATH=$PATH:$HADOOP_HOME/bin\" >> /etc/profile"
	ssh $user@$ip " echo \"export PATH=$PATH:$HADOOP_HOME/sbin\" >> /etc/profile"

	ssh $user@$ip " echo \"export HBASE_HOME=/home/hadoop/hbase\" >> /etc/profile"
	ssh $user@$ip " echo \"export PATH=$PATH:$HBASE_HOME/bin\" >> /etc/profile"
	ssh $user@$ip " echo \"export PATH=$PATH:$HBASE_HOME/sbin\" >> /etc/profile"

	#config file   copy hadoop hbase files to target

	#copy set to host 
	scp -r /etc/hosts $user@$ip:/etc/hosts
	
	#copy hadoop config 
	scp -r hadoopconf/* $user@$ip:/$packageBase/hadoop/conf/
	#copy hbase config 
	scp -r hbaseconf/* $user@$ip:/$packageBase/hbase/conf/


done







