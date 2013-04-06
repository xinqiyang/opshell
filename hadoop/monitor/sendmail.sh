#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

# for test email sending, edit a email, save as emailbody.txt,run
# ./sendemail.sh  emailbody.txt
#
# And uncomment EMAIL="Zhouhh@aaa.com,zhouhh@bbb.com", modify to your email address
# Email To ?
#EMAIL="Zhouhh@aaa.com,zhouhh@bbb.com"
# script to send simple email
if [ "$#" -lt 1 ]; then 
    echo "cant send email."
    echo "usage:"
    echo "  $0 mail_msg_file [mail_title]"
    exit 0
fi
echo "sendmail args:$@"
# email subject
#SUBJECT="Hadoop 系统告警"
SUBJECT="Hadoop.System.Warning"
if [ "$#" -ge 2 ]; then
    SUBJECT=$2
fi

# Email text/message
EMAILMESSAGE=$1
#echo "send msg file:$EMAILMESSAGE" 

# send an email using /bin/mail
# you should config MTA such as Postfix to send email
/bin/mail -s "${SUBJECT}" "${EMAIL}" < ${EMAILMESSAGE}

# or you can write a php or other email send web service to send email
#MSG=`cat ${EMAILMESSAGE}`
#curl -d "title=${SUBJECT}&content=${MSG}&address=${EMAIL}" http://192.168.10.42/pushmail.php
