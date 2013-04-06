#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

count=1
SHELL=/bin/bash
LANG=zh_CN.UTF-8
LANGUAGE=zh
LC_CTYPE=zh_CN.UTF-8
#echo $LANG

Path=$HOME
cd $Path/smr 
source config.sh

#clear fail data
source cleardata.sh
while test $count -gt 0; 
do
    echo "----------------------check memory --------------------------"
    ./memcheck.sh
    
    source failcheck.sh -m $MEMMSG -t $MTITLE -c $MFCOUNT -s $MFCOUNT_TOTAL 
    
    sleep 1 
  

    echo "" 
    echo "----------------------check disck space--------------------------"
    ./discheck.sh
    source failcheck.sh -m $DISKMSG -t $DTITLE -c $DFCOUNT -s $DFCOUNT_TOTAL 
    sleep 1 
    
    echo "" 
    echo "----------------------check process --------------------------"
    ./pcheck.sh
    source failcheck.sh -m $PROCMSG -t $PTITLE -c $PFCOUNT -s $PFCOUNT_TOTAL  
    sleep 1 
    
    let "count=$count-1"
    echo "----------------------end--------------------------"
done
