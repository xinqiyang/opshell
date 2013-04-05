#!/bin/bash

# up images to upyun
# author:xinqiyang
# up images to upyun.com to share the images 

HOST=”v0.ftp.upyun.com”
USER=”username”  #username
PASS=”password”  #password
LCD=”localpath”  #change local
RCD=”remotepath” #change remote
lftp -c “open ftp://$HOST;
user $USER $PASS;
lcd $LCD;
cd $RCD;
mirror –reverse \
–delete \
–dereference \
–verbose \
–exclude-glob=*.php”
