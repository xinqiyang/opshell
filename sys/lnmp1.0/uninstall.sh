#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, use sudo sh $0"
    exit 1
fi

clear
echo "========================================================================="
echo "Uninstall LNMP or LNMPA,  Written by Licess"
echo "========================================================================="
echo "A tool to auto-compile & install Nginx+MySQL+PHP on Linux "
echo ""
echo "For more information please visit http:/www.lnmp.org/"
echo ""
echo "Please backup your mysql data and configure files first!!!!!"
echo ""
echo "========================================================================="

echo ""
	uninstall=""
	echo "INPUT 1 to uninstall LNMP"
	echo "INPUT 2 to uninstall LNMPA"
	read -p "(Please input 1 or 2):" uninstall

	case "$uninstall" in
	1)
	echo "You will uninstall LNMP"
	echo "Please backup your configure files and mysql data!!!!!!"
	echo "The following directory or files will be remove!"
	cat << EOF
/usr/local/php
/usr/local/nginx
/usr/local/mysql
/usr/local/zend
/etc/my.cnf
/root/vhost.sh
/root/lnmp
/root/run.sh
/etc/init.d/php-fpm
/etc/init.d/nginx
/etc/init.d/mysql
EOF
	;;
	2)
	echo "You will uninstall LNMPA"
	echo "Please backup your configure files and mysql data!!!!!!"
	echo "The following directory or files will be remove!"
	cat << EOF
/usr/local/php
/usr/local/nginx
/usr/local/mysql
/usr/local/zend
/usr/local/apache
/etc/my.cnf
/root/vhost.sh
/root/lnmp
/root/run.sh
/etc/init.d/php-fpm
/etc/init.d/nginx
/etc/init.d/mysql
/etc/init.d/httpd
EOF
	esac

echo "Please backup your configure files and mysql data!!!!!!"

	get_char()
	{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
	}
	echo ""
	echo "Press any key to start uninstall LNMP , please wait ......"
	char=`get_char`

function uninstall_lnmp
{
	/etc/init.d/nginx stop
	/etc/init.d/mysql stop
	/etc/init.d/php-fpm stop

	rm -rf /usr/local/php
	rm -rf /usr/local/nginx
	rm -rf /usr/local/mysql
	rm -rf /usr/local/zend

	rm -f /etc/my.cnf
	rm -f /root/vhost.sh
	rm -f /root/lnmp
	rm -f /root/run.sh
	rm -f /etc/init.d/php-fpm
	rm -f /etc/init.d/nginx
	rm -f /etc/init.d/mysql
	echo "LNMP Uninstall completed."
}

function uninstall_lnmpa
{
	/etc/init.d/nginx stop
	/etc/init.d/mysql stop
	/etc/init.d/php-fpm stop

	rm -rf /usr/local/php
	rm -rf /usr/local/nginx
	rm -rf /usr/local/mysql
	rm -rf /usr/local/zend
	rm -rf /usr/local/apache

	rm -f /etc/my.cnf
	rm -f /root/vhost.sh
	rm -f /root/lnmp
	rm -f /root/run.sh
	rm -f /etc/init.d/php-fpm
	rm -f /etc/init.d/nginx
	rm -f /etc/init.d/mysql
	rm -f /etc/init.d/httpd
	echo "LNMPA Uninstall completed."
}

if [ "$uninstall" = "1" ]; then
	uninstall_lnmp
else
	uninstall_lnmpa
fi

echo "========================================================================="
echo "Uninstall LNMP or LNMPA,  Written by Licess"
echo "========================================================================="
echo "A tool to auto-compile & install Nginx+MySQL+PHP on Linux "
echo ""
echo "For more information please visit http://www.lnmp.org/"
echo ""
echo "========================================================================="