#!/bin/bash 
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

source checkopts.sh "$@"


sendcount=$SENDCOUNT

fails=0
sends=0

sendmail=false
checkfails()
{


    if [ -f "$COUNTFILE" ]; then
        fails=$(cat $COUNTFILE)
        echo "fails:$fails"
    
    else
        fails=0
    fi


    return $fails
}

checksend()
{

    sendmail=true
    echo "check send:$SENDCOUNTFILE"
    if [ -f "$SENDCOUNTFILE" ]; then
        sends=$(cat $SENDCOUNTFILE)
        echo "send count:$sends"
        if [ $sends -ge $sendcount ]; then
            echo "send count great than $sendcount times of $MSGFILE"
            
            sendmail=false
            return 127
            
        fi
        let "sends=$sends + 1"
        
    else
      sends=1
    fi

    echo $sends > $SENDCOUNTFILE


}

checkfails
echo "fail times:$fails"
if [ $fails -gt 0 ]; then

    checksend
    echo "send?$sendmail"
    if [ $sendmail = true ] ; then

        echo "send mail: $MSGFILE $TITLE$sends"
        source sendmail.sh $MSGFILE "$TITLE$sends"
    fi
else
    source cleardata.sh $COUNTFILE
    source cleardata.sh $SENDCOUNTFILE
    if [ -f $MSGFILE ]; then
        mv $MSGFILE $MSGFILE.$(date +%y-%m-%d-%T).bak;
    fi

fi

