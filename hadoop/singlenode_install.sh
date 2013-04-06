#!/bin/bash

if [ `id -u` == 0 ]; then
  echo "must not be root!"
  exit 0
fi

#init dirs
mkdir -p ~/packages/hadoop


#hadoop install
if [ ! -d ~/packages/hadoop/ ]; then
   mkdir ~/packages/hadoop/
fi

#get hadoop packages from net
wget http://archive.apache.org/dist/h ... hadoop-1.0.3.tar.gz -O ~/packages/hadoop/hadoop-1.0.3.tar.gz
tar xvzf ~/packages/hadoop/hadoop-*.tar.gz -C ~/packages/hadoop/
rm ~/packages/hadoop/hadoop-*.tar.gz

#hadoop config
if [ $(getconf LONG_BIT) == 64 ]; then
  echo "export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64" >> /etc/profile
else
  echo "export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386" >> /etc/profile
fi
echo "export HADOOP_HOME=~/packages/hadoop/hadoop-1.0.3" >> /etc/profile
echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$JAVA_HOME/bin" >> /etc/profile
echo "export HADOOP_HOME_WARN_SUPPRESS=1" >> /etc/profile

#hadoop core-site.xml
echo "<?xml version='1.0'?>" > ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "<configuration>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "  <property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "    <name>fs.default.name</name>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "    <value>hdfs://localhost:9000</value>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "  </property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "  <property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "    <name>hadoop.tmp.dir</name>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "    <value>~/packages/hadoop/tmp</value>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "  </property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml
echo "</configuration>" >> ~/packages/hadoop/hadoop-1.0.3/conf/core-site.xml

#hadoop hdfs-site.xml
echo "<?xml version='1.0'?>" > ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "<configuration>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "  <property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <name>dfs.name.dir</name>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <value>~/packages/hadoop/name</value>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "  </property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "  <property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <name>dfs.data.dir</name>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <value>~/packages/hadoop/data</value>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "  </property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "  <property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <name>dfs.replication</name>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "    <value>2</value>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "  </property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml
echo "</configuration>" >> ~/packages/hadoop/hadoop-1.0.3/conf/hdfs-site.xml

#hadoop mapred-site.xml
echo "<?xml version='1.0'?>" > ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml
echo "<?xml-stylesheet type='text/xsl' href='configuration.xsl'?>" >> ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml
echo "<configuration>" >> ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml
echo "  <property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml
echo "    <name>mapred.job.tracker</name>" >> ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml
echo "    <value>localhost:9001</value>" >> ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml
echo "  </property>" >> ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml
echo "</configuration>" >> ~/packages/hadoop/hadoop-1.0.3/conf/mapred-site.xml

source /etc/profile
hadoop nomenode -fromat
$HADOOP_HOME/bin/start-all.sh

