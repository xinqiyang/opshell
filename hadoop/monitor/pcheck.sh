#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

source config.sh

for h in ${hosts[@]}; 
do
    echo
    echo "====host:$h===="
   
    pss=$(eval "echo \${${h}[@]}")
    
    source phandle.sh $h $pss
done

