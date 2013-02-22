#!/bin/sh
for i in `ls -lthr | head -3 |grep -v 'total'`
do
 rm -rf  $i
done;
