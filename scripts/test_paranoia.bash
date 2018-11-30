#!/usr/bin/env bash

# make sure that rsh config prevents users from doing things that they shouldn't be able to

# also hard-code transfer account name

# assume that there's been a single script run, so there's a single keyfile / single hostkey file in /tmp
n_kfs=`ls -1 /tmp/keyfile* | wc -l`
if [ "1" != "${n_kfs}" ]; then
	echo "multiple keyfiles not supported yet; bailing out"
	exit 1
fi
kf=`ls -1 /tmp/keyfile*`
hk=`ls -1 /tmp/hostkey*`

# let's try to execute a command, should fail.
ssh -i $kf -o UserKnownHostsFile=${hk} dset1@dcm ls
err_cmd=$?
if [ 0 -eq ${err_cmd} ]; then
	echo "ERROR - transfer user can execute commands"
	exit 1
fi

# let's try to copy a system file we shouldn't be able to read
scp -i $kf -o UserKnownHostsFile=${hk} dset1@dcm:/etc/shadow .
err_scp1=$?
if [ 0 -eq ${err_cmd} ]; then
	echo "ERROR - transfer user copy system files out"
	exit 1
fi

echo "done checking paranoia"
