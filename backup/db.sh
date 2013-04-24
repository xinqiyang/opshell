#!/bin/bash 
#

cd /home/wwwroot/backup 
date=`date -I`; 

/usr/bin/mysqldump -u root --password=123456 website > website_$date.sql 

/bin/gzip -9 website_$date.sql

