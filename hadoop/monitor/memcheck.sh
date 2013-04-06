#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

source config.sh

export total=0
used=0
free=0
export realused=0
realfree=0
usep=0

for ahost in ${hosts[@]};
do
    echo "====host:$ahost===="
    #item,total,used,free
    ssh -f $ahost 'free -m' | grep -vE 'total|^Swap' | awk '{ print $1 " " $2 " " $3 " " $4 }' | while read output;
    do
      #echo $output
      if echo $output | grep -q  "^Mem:" ; then
          total=$(echo $output | awk '{ print $2}') 
          used=$(echo $output | awk '{ print $3}')
          free=$(echo $output | awk '{ print $4}')
          echo $total>.total
      fi
      if echo $output | grep -q  "^-/+" ; then
          let realused=$(echo $output | awk '{ print $3}') 
          realfree=$(echo $output | awk '{ print $4}')
          echo "$ahost  real used:$realused,real free:$realfree"
          echo $realused > .realused
      fi
    done

    realused=$(cat .realused)
    total=$(cat .total)

    #echo "readused:$realused"
    #echo "total:$total"
    let usep=($realused*100)/$total
    #echo "usep:$usep"
    if [ $usep -ge $MEMALERT ]; then
        echo "[$(date +%y-%m-%d,%T)] [$ahost] $partition ($usep%) Running out of memory. "
        echo "[$(date +%y-%m-%d,%T)] [$ahost] $partition ($usep%) Running out of memory. " >> $MEMMSG
        source failhandle.sh -m $MEMMSG -t $MTITLE -c $MFCOUNT

    fi
    echo ""

done
