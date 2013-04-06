#!/bin/bash

# Name: hadoop_install.sh
# Purpose: For Fast Hadoop Installation of the producting env, to save time for life :) 
# Author: xinqiyang@gmail.com
# Time: 05/04/2013
# User: hadoop user "hadoop"
# Attention: Passwordless SSH access need to be set up 1st between different nodes
#            to allow the script to take effect!

############################################################################
### Different env variables setting. Please change this part according to
### your specific env ...
############################################################################
export HDPPKG='hadoop-1.0.3.tar.gz'
export HDPLOC='/home/hdpadm/hadoop'
export HDPADMHM='/home/hdpadm'
export MASTER01='hdp01.dbinterest.local'
export SLAVE01='hdp02.dbinterest.local'
export SLAVE02='hdp03.dbinterest.local'
export HDPLINK='http://archive.apache.org/dist/hadoop/core/stable/hadoop-1.0.3.tar.gz'

export SLAVES="hdp02.dbinterest.local hdp03.dbinterest.local"
export USER='hdpadm'

############################################################################
### For the script to run, the hadoop user "hdpadm" should be set up first!
### And the SSH Passwordless should be set up for all the nodes ...
############################################################################
#/usr/sbin/groupadd hdpadm
#/usr/sbin/useradd hdpadm -g hdpadm

# Run as new user "hdpadm" on each node
# ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
# eg: ssh-copy-id -i ~/.ssh/id_rsa.pub hdp01.dbinterest.local
# Syntax: ssh-copy-id [-i [identity_file]] [user@]machine

############################################################################
### Get the Hadoop the packages and prepare the installation
############################################################################
if [ ! -d $HDPLOC ]; 
        then
                  mkdir $HDPLOC
                  cd $HDPLOC
fi


if [ ! -f "$HDPPKG" ]; 
        then
                echo "Getting the Hadoop the packages and prepare the installation..."
                wget $HDPLINK -O $HDPLOC/$HDPPKG
                tar xvzf $HDPLOC/$HDPPKG -C $HDPLOC
                rm -f $HDPLOC/$HDPPKG
fi

############################################################################
### Hadoop config Step by Step 
############################################################################

# Config the profile
echo "Configuring the profile..."
if [ $(getconf LONG_BIT) == 64 ]; then
  echo '' >> $HDPADMHM/.bash_profile        
  echo "#Added Configurations for Hadoop" >> $HDPADMHM/.bash_profile
  echo "export JAVA_HOME=/usr/jdk64/jdk1.6.0_31" >> $HDPADMHM/.bash_profile
else
  echo "export JAVA_HOME=/usr/jdk32/jdk1.6.0_31" >> $HDPADMHM/.bash_profile
fi

echo "export HADOOP_HOME=/home/hdpadm/hadoop/hadoop-1.0.3" >> $HDPADMHM/.bash_profile
echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$JAVA_HOME/bin" >> $HDPADMHM/.bash_profile
echo "export HADOOP_HOME_WARN_SUPPRESS=1" >> $HDPADMHM/.bash_profile

#hadoop core-site.xml
echo "Configuring the core-site.xml file..."
echo "<?xml version='1.0'?>" > $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "<configuration>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "  <property>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "    <name>fs.default.name</name>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "    <value>hdfs://$MASTER01:9000</value>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "  </property>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "  <property>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "    <name>hadoop.tmp.dir</name>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "    <value>$HDPLOC/tmp</value>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "  </property>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml
echo "</configuration>" >> $HDPLOC/hadoop-1.0.3/conf/core-site.xml

#hadoop hdfs-site.xml
echo "Configuring the hdfs-site.xml..."
echo "<?xml version='1.0'?>" > $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "<configuration>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "  <property>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <name>dfs.name.dir</name>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <value>$HDPLOC/name</value>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "  </property>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "  <property>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <name>dfs.data.dir</name>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <value>$HDPLOC/data</value>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "  </property>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "  <property>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <name>dfs.replication</name>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <value>2</value>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "  </property>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml
echo "</configuration>" >> $HDPLOC/hadoop-1.0.3/conf/hdfs-site.xml

#hadoop mapred-site.xml
echo "Configuring mapred-site.xml file..."
echo "<?xml version='1.0'?>" > $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml
echo "<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>" >> $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml
echo "<configuration>" >> $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml
echo "  <property>" >> $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml
echo "    <name>mapred.job.tracker</name>" >> $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml
echo "    <value>$MASTER01:9001</value>" >> $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml
echo "  </property>" >> $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml
echo "</configuration>" >> $HDPLOC/hadoop-1.0.3/conf/mapred-site.xml

echo "Configuring the masters, slaves and hadoop-env.sh files..."
#hadoop "masters" config
echo "$MASTER01" > $HDPLOC/hadoop-1.0.3/conf/masters

#hadoop "slaves" config
echo "$SLAVE01" > $HDPLOC/hadoop-1.0.3/conf/slaves
echo "$SLAVE02" >> $HDPLOC/hadoop-1.0.3/conf/slaves

#hadoop "hadoop-env.sh" config
echo "export JAVA_HOME=/usr/jdk64/jdk1.6.0_31" > $HDPLOC/hadoop-1.0.3/conf/hadoop-env.sh
echo 'export HADOOP_NAMENODE_OPTS="-Dcom.sun.management.jmxremote $HADOOP_NAMENODE_OPTS"' >> $HDPLOC/hadoop-1.0.3/conf/hadoop-env.sh 
echo 'export HADOOP_SECONDARYNAMENODE_OPTS="-Dcom.sun.management.jmxremote $HADOOP_SECONDARYNAMENODE_OPTS"' >> $HDPLOC/hadoop-1.0.3/conf/hadoop-env.sh 
echo 'export HADOOP_DATANODE_OPTS="-Dcom.sun.management.jmxremote $HADOOP_DATANODE_OPTS"' >> $HDPLOC/hadoop-1.0.3/conf/hadoop-env.sh 
echo 'export HADOOP_BALANCER_OPTS="-Dcom.sun.management.jmxremote $HADOOP_BALANCER_OPTS"' >> $HDPLOC/hadoop-1.0.3/conf/hadoop-env.sh 
echo 'export HADOOP_JOBTRACKER_OPTS="-Dcom.sun.management.jmxremote $HADOOP_JOBTRACKER_OPTS"' >> $HDPLOC/hadoop-1.0.3/conf/hadoop-env.sh 

# Copy the config files and hadoop folder from "master" to all "slaves"

for slave in $SLAVES
do
        echo "------Copying profile and hadoop directory-------" 
        scp $HDPADMHM/.bash_profile $USER@$slave:$HDPADMHM/.bash_profile
        ssh $USER@$slave source $HDPADMHM/.bash_profile
        scp -r $HDPLOC $USER@$slave:/home/hdpadm
done        

source $HDPADMHM/.bash_profile
#hadoop namenode -format
#$HADOOP_HOME/bin/start-all.sh
