#!/usr/bin/env bash

#/etc/init.d/sshd start
# sshd initialization
hkts="rsa ecdsa ed25519"
for hkt in $hkts
do
	ssh-keygen -t ${hkt} -f /etc/ssh/ssh_host_${hkt}_key -N ''
done
if [ ! -d /var/run/sshd ]; then
	mkdir -p /var/run/sshd
fi
/usr/sbin/sshd

#/etc/init.d/redis start
redis-server &
/etc/init.d/rq start
lighttpd -D -f /etc/lighttpd/lighttpd.conf
