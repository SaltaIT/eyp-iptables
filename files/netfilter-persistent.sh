#!/bin/bash

# workaround script for SLES 12.3

start_iptables()
{
  if [ -f /etc/sysconfig/iptables-rules.v4 ];
  then
    cat /etc/sysconfig/iptables-rules.v4 | iptables-restore
  fi

  if [ -f /etc/sysconfig/iptables-rules.v6 ];
  then
    cat /etc/sysconfig/iptables-rules.v6 | ip6tables-restore
  fi
}

save_iptables()
{
  /usr/sbin/iptables-save > /etc/sysconfig/iptables-rules.v4
  /usr/sbin/ip6tables-save > /etc/sysconfig/iptables-rules.v6
}

stop_iptables()
{
  iptables -F -t filter
  iptables -F -t nat
  iptables -F -t mangle
  iptables -F -t raw
  iptables -F -t security
}

if [ "$(whoami)" != "root" ];
then
  echo "You must be root to use this utility"
fi

case $1 in
  start|flush)
    start_iptables
  ;;
  reload|restart)
    stop_iptables
    start_iptables
  ;;
  stop|flush)
    stop_iptables
  ;;
  save)
    save_iptables
  ;;
  *)
    echo "Usage: ${0} (start|stop|restart|reload|save|flush)"
  ;;
esac

exit 0
