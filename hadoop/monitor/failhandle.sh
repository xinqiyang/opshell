#!/bin/bash 
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.


source checkopts.sh "$@"


failcount=$FAILCOUNT


function handlefails()
{

    if [ $# -ge 1 ]; then
        failcount=$1
    fi

    if [ -f "$COUNTFILE" ]; then
        fails=$(cat $COUNTFILE)
        echo "fails:$fails"
        if [ $fails -ge $failcount ]; then
            echo "fail count great than $failcount times fails of $MSGFILE"
       # exit 0
        else
            let "fails=$fails+1"
        fi
    
    else
        fails=1
    fi


    echo "after check fails:$fails"
    echo "$fails" > $COUNTFILE
    return $fails
}

handlefails
