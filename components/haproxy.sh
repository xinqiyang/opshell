#!/bin/bash
#
# haproxy  Startup script for the haproxy Server,write by gabylinux
#
# chkconfig: - 86 14
# description: haproxy
# processname: haproxy
# config: /usr/local/haproxy/haproxy.cfg
# pidfile: /usr/local/haproxy/haproxy.pid
# Source function library.
. /etc/rc.d/init.d/functions
# Source networking configuration.
. /etc/sysconfig/network
# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

HAPROXY_CONF_FILE=/usr/local/haproxy/haproxy.cfg
haproxy="/usr/local/haproxy/sbin/haproxy"
prog=$(basename $haproxy)
lockfile=/var/lock/subsys/haproxy

start() {
    [ -x $haproxy ] || exit 5
    [ -f $HAPROXY_CONF_FILE ] || exit 6
    echo -n $"Starting $prog: "
    daemon $haproxy -f $HAPROXY_CONF_FILE
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
    echo "ok"
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog -9
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    #configtest || return $?
    stop
    sleep 1
    start
}

reload() {
    #configtest || return $?
    echo -n $"Reloading $prog: "
    killproc $haproxy -HUP
    RETVAL=$?
    echo
}

rh_status() {
    status $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart|configtest)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
  *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac
