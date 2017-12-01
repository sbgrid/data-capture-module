#!/bin/sh

/etc/init.d/redis start
/etc/init.d/rq start
#rq worker normal
lighttpd -D -f /etc/lighttpd/lighttpd.conf
