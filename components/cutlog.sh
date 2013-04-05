#!/bin/bash

# cut nginx log
# author:xinqiyang
# set crontab
# 00 00 * * * /cutlog.sh freeflare/api 2>&1 >/dev/null &

p=$1
if [ "$p" = "" ]; then
   echo "Plear input project name!";
   exit
fi

# The Nginx logs path
logs_path="/logs/nginx/"$p
logs_dir=${logs_path}/$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")
logs_file=$(date -d "yesterday" +"%Y%m%d")
mkdir -p /logs/nginx/backuplogs/$p/$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")
tar -czf ${logs_path}/${logs_file}.tar.gz ${logs_path}/*.log
rm -rf ${logs_path}/*.log
mv ${logs_path}/${logs_file}.tar.gz /logs/nginx/$p/backuplogs/$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")

#reload nginx
/usr/local/nginx/sbin/nginx -s reload

for oldfiles in `find /logs/nginx/$p/backuplogs/$(date -d "30 days ago" +"%Y")/$(date -d "30 days ago" +"%m")/  -type f -mtime +30`
do
     rm -f $oldfiles
done
