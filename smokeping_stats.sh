#!/bin/sh
: '
snmpd extend supports only integers 0-255, something to do with exit codes???
using pass with custom oid

# add this to /etc/snmp/snmpd.conf
pass .1.3.9950.1.1 /bin/sh /etc/smokeping/smokeping_stats.sh process_number
pass .1.3.9950.1.2 /bin/sh /etc/smokeping/smokeping_stats.sh cache_size
pass .1.3.9950.1.3 /bin/sh /etc/smokeping/smokeping_stats.sh rrd_unchanged_count
pass .1.3.9950.1.4 /bin/sh /etc/smokeping/smokeping_stats.sh process_main
'
case $1 in
        process_number)
                echo .1.3.9950.1.1
                echo integer
                ps aux | grep smokeping | wc -l
                ;;
        cache_size)
                echo .1.3.9950.1.2
                echo integer
                du /var/run/smokeping/ | cut -f1
                ;;
        rrd_unchanged_count)
                echo .1.3.9950.1.3
                echo integer
                find /var/lib/smokeping/ -name '*rrd' -mmin +60 -type f -exec ls -l {} + | wc -l
                ;;
        process_main)
                echo .1.3.9950.1.4
                echo integer
                cmd=`pgrep -x smokeping`
                if [ $cmd ]
                then
                        echo $cmd
                else
                        echo 0
                fi
                ;;
        lastgithook)
                echo .1.3.9950.1.5
                echo integer
                grep 'ERROR' /etc/smokeping/smokeping_lastgithook.log  | wc -l
                ;;
        *)
        echo Invalid args
        ;;
esac
