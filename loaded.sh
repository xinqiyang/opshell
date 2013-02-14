#/bin/bash

LOAD=$(awk '{print $1}' /proc/loadavg)
CPUNUM=$(grep processor /proc/cpuinfo | wc -l)

if [ $(echo "$LOAD > $CPUNUM"|bc)=1 ]; then
        RESULT=$(ps -eo pcpu,pmem,user,args | awk '$1 > 0' | sort -nr)
        if [ -n "$RESULT" ]; then
                echo "$RESULT" > ./ps.$(date +"%Y%m%d%H%M")
        fi  
fi
