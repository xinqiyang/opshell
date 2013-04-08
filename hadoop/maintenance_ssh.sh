#!/bin/sh
#Filename：maintenance_ssh.sh
#Explain: Hadoop's MASTER,SLAVE generate SSH secret key for known_hosts
# root need.
#Version:1.00
#DATA:2013-04-05

MASTER='/home/hadoop/hadoop/conf/masters'
SLAVE='/home/hadoop/hadoop/conf/slaves'
IPLIST=`cat $MASTER $SLAVE`

echo "`date +"%F %T"` start $0"
[ $UID -ne 0 ] && echo "please use root run scripts" && exit 1
[ -f /root/.ssh/known_hosts ] && rm -f /root/.ssh/known_hosts
[ -f $0""error.iplist ]       && rm -f $0""error.iplist
for i in {1};do
    for ip in $IPLIST;do
        host=`grep "$ip" /etc/hosts|awk 'END{print $2}'`
        if [[  -z $host ]];then
            echo "`date +"%F %T"` ERROR:This $ip hostname not find in /etc/hosts."
            exit 1
        fi
        #sleep 1
        ssh -o StrictHostKeyChecking=no $host >/dev/null 2>&1 && \
        echo "`date +"%F %T"` INFO: $ip $hosts known_hosts is created." &
    done
    sleep 5  #sleep waiting
    for ip in $IPLIST;do
        host=`grep "$ip" /etc/hosts|awk 'END{print $2}'`
        scp /root/.ssh/known_hosts root@$host:/root/.ssh/known_hosts
        if [ $? -eq 0 ];then
            echo "`date +"%F %T"` INFO: Copy known_hosts to $host ok."
        else
            echo "`date +"%F %T"` ERROR: Copy known_hosts to $host error."
            echo "$ip  $hosts" >> $0""error.iplist
        fi
    done
echo "`date +"%F %T"` stop $0 and exit" && exit 0
done

