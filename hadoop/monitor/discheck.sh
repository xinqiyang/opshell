#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

source config.sh

for ahost in ${hosts[@]};
do
    
    echo "===host:$ahost==="
    ssh -f $ahost 'df -H' | grep -vE '^文件系统|^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
    do
      usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1 )
      partition=$(echo $output | awk '{ print $2 }' )
      if [ $usep -ge $DISALERT ]; then
        echo "[$(date +%y-%m-%d,%T)] [$ahost] $partition ($usep%) Running out of space. " >> $DISKMSG
        echo "-m ${DISKMSG} -t ${DTITLE} -c ${DFCOUNT}"
        source failhandle.sh -m ${DISKMSG} -t ${DTITLE} -c ${DFCOUNT} 
      fi
    done
done
