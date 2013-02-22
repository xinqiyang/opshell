#!/bin/bash
#author:xinqiyang
# start mysql scripts
mysqld_safe --basedir=/usr/local/mysql --datadir=/storages/mysql/3306 --user=mysql >/dev/null &
