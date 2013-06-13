#!/bin/sh
##
## chmod +x backup.sh
## crontab -e
## 0 4 * * * sh /root/backup2dropbox.sh restart  
## 0 5 * * * sh /root/backup2dropbox.sh stop

BACKUP_SRC="/home/backup"  
BACKUP_WWW="/home/wwwroot"     
NOW=$(date +"%Y.%m.%d")
MYSQL_SERVER="127.0.0.1"
MYSQL_USER="root"
MYSQL_PASS=""
DAY=$(date +"%u")

start() {

mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS databasename > "$BACKUP_SRC/$NOW-Databases.sql"
cp -r $BACKUP_WWW $BACKUP_SRC

if [ "$DAY" -eq "7" ] ;
then
  tar cfz "$BACKUP_SRC/$NOW-www.tgz" $BACKUP_WWW ;
fi
echo starting dropbox
/root/.dropbox-dist/dropboxd &
}
stop() {
echo stoping dropbox
pkill dropbox
}
case "$1" in
start)
start
;;
stop)
stop
;;
restart)
stop
start
;;
esac