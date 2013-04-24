#!/bin/bash 
#
#
root=/home/wwwroot
date=`date -I`; 
# backup website
websites=`cat ./site.conf`;
echo $websites;
for w in $websites;do
	echo "/bin/tar -cjf ./backup/$w_$date.tar.bz2 $w"
done
# romove old data 
#find ./backup -type f -mtime +7 -exec rm -f {} \



