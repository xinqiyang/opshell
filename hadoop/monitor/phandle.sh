#!/bin/bash
# author:zhouhh 
# date:2012.8.17
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

host=$1
shift
pss=$@
#echo $pss
live=false
PROCS=data/.process.txt

: > $PROCS

#pipe subshell, write file to get result
ssh -f $host '/usr/java/jdk1.7.0/bin/jps' | grep -vE 'Jps|^ ' | awk '{ print $2 }' | while read hostedps
do
  echo $hostedps >>$PROCS
done


hps=$(cat $PROCS)

echo "should exist ps:$pss"
echo "existed process:$hps" | tr "\n" " "
echo ""
for p in $pss; do 
    live=false
    
    for  hp in $hps ; do 
        if [ $p == $hp ]; then 
            live=true
            break
          else
              
              continue
          fi
    done
    if [ $live = false ]; then
        
      echo "$p not in $pss"
      
      echo "[$(date +%y-%m-%d,%T)] [$host]  process :$p is not exist" >> $PROCMSG
      source failhandle.sh -m $PROCMSG -t $PTITLE -c $PFCOUNT

    fi
done

