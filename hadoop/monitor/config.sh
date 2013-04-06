#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.


#configure for processes to be checked
#set -vx
#where to put smr
# also should modify the loopcheck.sh
path=$HOME
w=$path/smr
cd $w
#monitor hosts names
hosts=(h46 h47 h48)

#warning emails send  to 
EMAIL="zhouhh@aaa.com,zhouhh@example.com"


# set disk alert level percent
DISALERT=85 

# set memory alert level percent
MEMALERT=95 

#send how many mails to stop
SENDCOUNT=5

#file config
MEMMSG=$w/data/memmsg.txt
MFCOUNT=$w/data/failcountmem.txt
MFCOUNT_TOTAL=$w/data/total_failcountmem.txt
#MTITLE="Hadoop内存告警!!"
MTITLE="Hadoop-memory-warning"

DISKMSG=$w/data/discmsg.txt
DFCOUNT=$w/data/failcountd.txt
DFCOUNT_TOTAL=$w/data/total_failcountd.txt
#DTITLE="Hadoop磁盘告警!!"
DTITLE="Hadoop-disk-full-warning"

PROCMSG=$w/data/procmsg.txt
PFCOUNT=$w/data/failcountproc.txt 
PFCOUNT_TOTAL=$w/data/total_failcountproc.txt 
#PTITLE="Hadoop进程监控告警!!"
PTITLE="Hadoop-process-exit-warning"

#process monitor config
h47=(
    HRegionServer
    TaskTracker
    DataNode
    ThriftServer
    SecondaryNameNode
)
h48=(
    HRegionServer
    TaskTracker
    DataNode
    HQuorumPeer
    ThriftServer
)
h46=(
    HMaster
    JobTracker
    NameNode
    HQuorumPeer
    ThriftServer
)

