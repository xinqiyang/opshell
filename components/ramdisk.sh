#!/bin/bash

####
### create ramdisk for temp cache
###

##
cd /tmp/
mkdir fscache
mount -t tmpfs -o size=100m,mode=0755 tmpfs /tmp/fscache/

chmod -R 777 /tmp/fscache

### @todo :
### need to clear per hour
### 



