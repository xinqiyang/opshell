#!/bin/bash
# Name: hadoop_init.sh
# Purpose: For Fast INITIALIZATION of the producting env, to save time for life :) 
# Author: xinqiyang@gmail.com
# Time: 05/04/2013
# User: root
# Reminder:  1) Remember to add the executable permission the script before start the script
#                          eg: chmod a+x env_ini.bash OR chmod 744 env_ini.bash
#            2) Need to change the $HOSTNAME2BE and $HOST_IP variable on each node accordingly.
# Attention: 1) You might need run this script TWICE to have the server ip address in effect
#                 	   if the ifconfig output shows deivce other than "eth0"!!!
#            2) Please execute the script from the console inside the node, not form ssh tool
#            like xshell, SecureCRT, etc. to avoid connection lost.


############################################################################
### Different env variables setting. Please change this part according to
### your specific env ...
############################################################################

#init host
export HOST01='192.168.1.121 hdp01.dbinterest.local hdp01'
export HOST02='192.168.1.122 hdp02.dbinterest.local hdp02'
export HOST03='192.168.1.123 hdp03.dbinterest.local hdp03'

export BAKDIR='/root/bak_dir'

export HOSTSFILE='/etc/hosts'
export NETWORKFILE='/etc/sysconfig/network'

export CURRENT_HOSTNAME=`hostname`

### Modify hostname according to your node in the cluster

#export HOSTNAME2BE='hdp01.dbinterest.local'
#export HOSTNAME2BE='hdp02.dbinterest.local'
export HOSTNAME2BE='hdp03.dbinterest.local'

export ETH0STRING=`ifconfig | grep eth0`

export HWADDRSS=`ifconfig | grep HWaddr | awk '{print $5}'`
export IFCFG_FILE='/etc/sysconfig/network-scripts/ifcfg-eth0'

### Modify host IP address according to your node in the cluster

#export HOST_IP='192.168.1.121'
#export HOST_IP='192.168.1.122'
export HOST_IP='192.168.1.123'

export GATEWAYIP='192.168.1.1'
export DNSIP01='8.8.8.8'
export DNSIP02='8.8.4.4'

export FILE70='/etc/udev/rules.d/70-persistent-net.rules'

export DATETIME=`date +%Y%m%d%H%M%S`

export FQDN=`hostname -f`

### Make the backup directory for the different files
if [ -d $BAKDIR ];
        then
                echo "The backup directory $BAKDIR exists!"
        else
                echo "Making the backup directory $BAKDIR..."
                mkdir $BAKDIR
fi                

############################################################################
### Config the hosts file "/etc/hosts"
############################################################################

if [ -f $HOSTSFILE ];
        then
                cp $HOSTSFILE $BAKDIR/hosts\_$DATETIME.bak
                echo '127.0.0.1   localhost localhost.localdomain' > $HOSTSFILE
                echo '::1         localhost6 localhost6.localdomain6' >> $HOSTSFILE
                echo "$HOST01" >> $HOSTSFILE
                echo "$HOST02" >> $HOSTSFILE
                echo "$HOST03" >> $HOSTSFILE
        else
                echo "File $HOSTSFILE does not exists"
fi

############################################################################
### Config the network file "/etc/sysconfig/network"
############################################################################

if [ -f $NETWORKFILE ];
        then
                cp $NETWORKFILE $BAKDIR/network\_$DATETIME.bak
                echo 'NETWORKING=yes' > $NETWORKFILE
                echo "HOSTNAME=$HOSTNAME2BE" >> $NETWORKFILE
        else
                echo "File $NETWORKFILE does not exists"
fi

############################################################################
### Config the ifcfg-eth0 file "/etc/sysconfig/network-scripts/ifcfg-eth0"
############################################################################

if [ -f $IFCFG_FILE ];
        then
                cp $IFCFG_FILE $BAKDIR/ifcfg_file\_$DATETIME.bak
                echo 'DEVICE=eth0' > $IFCFG_FILE
                echo 'BOOTPROTO=static' >> $IFCFG_FILE
                echo "HWADDR=$HWADDRSS" >> $IFCFG_FILE
                echo "IPADDR=$HOST_IP" >> $IFCFG_FILE
                echo 'NETMASK=255.255.255.0' >> $IFCFG_FILE
                echo "GATEWAY=$GATEWAYIP" >> $IFCFG_FILE
                echo "DNS1=$DNSIP01" >> $IFCFG_FILE
                echo "DNS2=$DNSIP02" >> $IFCFG_FILE
                echo 'ONBOOT=yes' >> $IFCFG_FILE
fi

echo ''
echo "DEFAULT hostname is $CURRENT_HOSTNAME."
echo "Hostname is going to be changed to $HOSTNAME2BE..."
if [ "$CURRENT_HOSTNAME" != "$HOSTNAME2BE" ];
        then
                hostname $HOSTNAME2BE
        else
                echo "The hostname is already configured correctly!"
fi                                


############################################################################
### Check the current config setting for the different files
############################################################################
echo ''
echo -e "Current fully qualified domain name is: \n $FQDN"
echo "Current config setting for $HOSTSFILE, $NETWORKFILE and $IFCFG_FILE"
echo ''
echo $HOSTSFILE
cat $HOSTSFILE
echo ''
echo $NETWORKFILE
cat $NETWORKFILE
echo ''
echo $IFCFG_FILE
cat $IFCFG_FILE

############################################################################
### Stop Iptables and SELinux. The reboot will make those in effect!
############################################################################
echo ''
echo "Stopping Ipstables and SELinux ..."
service iptables stop
chkconfig iptables off

sed -i.bak 's/=enforcing/=disabled/g' /etc/selinux/config


############################################################################
### Restarting the network ...
############################################################################

echo ''
echo "Restarting network ..."
service network restart

############################################################################
### For the machine copying/cloning in the VMware env, network deive was 
### changed to "eth1" from "eth0" after the 1st time copying, and then "eth2" 
### the 2nd, then "eth3". For a consistent test env, all of them was changed
### to "eth0" ...
############################################################################

if [ -z "$ETH0STRING" ];
        then
                echo "Network device eth0 does NOT exists!!!"
            if [ -f $FILE70 ]; 
                    then        
                                echo "Now, deleting the the file $FILE70... and Rebooting..."
                                cp $FILE70 $BAKDIR/file70\_$DATETIME.bak
                                rm /etc/udev/rules.d/70-persistent-net.rules
                                reboot
                fi
else
                echo "Network device eth0 exists."
fi
