#!/usr/bin/env bash

# file upload script for deposition of dataset UID

uid=UID
pid=$$

hostport=22
hostname=UPLOADHOST
checksumfile=/tmp/files-${pid}.sha 
keyfile=/tmp/keyfile-${pid}

#check dependencies
function cmd_check()
{
        cmd=$1
        x=$(which $cmd 2> /dev/null)
        if [[ -e $x && -n $x ]]; then
                echo 0
        else
                echo 1
        fi
}
function pick_checksum()
{
        if (( 0 == $(cmd_check "sha1sum") )); then
                echo "sha1sum"
        else
                echo "shasum"
        fi
}
sha_cmd=$(pick_checksum)

deps="$sha_cmd rsync ssh bash find"
for dep in $deps
do
        if (( 0 != $(cmd_check $dep) )); then
                echo "error : $dep is currently required for this upload script"
                echo "please install this program, or contact support for assistance"
                exit
        fi
done

cat << eof > $keyfile
include(`.ssh/id_rsa')
eof
chmod og-rwx $keyfile

hostkey=/tmp/hostkey-${pid}
cat << eof > $hostkey
UPLOADHOST include(`/etc/ssh/ssh_host_rsa_key.pub')
eof

echo "DATAVERSE FILE UPLOAD SCRIPT"
echo "Please enter the full path of the directory containing data files to upload for dataset number: $uid"
echo "Make sure your data is stored under this single directory. All files within this directory and its subdirectories will be uploaded to your dataset."
read ddir
if [[ ! -d $ddir ]] || [[ -z $ddir ]] || [[ "$ddir" != /* ]]; then
	echo "There appears to be a problem with your upload directory name: $ddir"
	echo "This should be a full path (beginning with a '/'), non-empty, and point to a directory"
        exit
fi


xs=$(find $ddir -type f | sort)
echo "files to be uploaded in $ddir:"
for x in $xs
do
        echo $x
	if [ "$(basename $x)" == "files.sha" ]; then
		echo "files.sha is reserved for the checksum manifest, please remove or rename this file"
		exit 1
	fi
done
echo "is this correct (y/n)?"
read y

case "$y" in
        "y")
                echo "calculating checksum"
                cd $ddir
                $sha_cmd $(find . -type f) > $checksumfile 

                echo "transferring data"
		echo "This step may take minutes to hours - when it is complete, DATA TRANSFER COMPLETE message will be shown"
                rsync --protocol=29 --progress -a -e "ssh -i ${keyfile} -p ${hostport} -o UserKnownHostsFile=$hostkey" ${ddir}/ ${uid}@${hostname}:~/${uid}
		err=$?
		if [ 0 -ne $err ]; then
			#handle errors here
			echo "Unfortunately, something went wrong during data transfer."
			uname -a
			ssh -V
			ssh -i ${keyfile} -p ${hostport} -o UserKnownHostsFile=$hostkey -T ${uid}@${hostname}
			rsync --version
			$sha_cmd --version
			echo $uid
			echo "Please email the error text to support"
			exit 1
		else
			echo "DATA TRANSFER COMPLETE"

			echo "transferring checksum"
			scp -i ${keyfile} -P ${hostport} -o UserKnownHostsFile=$hostkey $checksumfile ${uid}@${hostname}:~/${uid}/files.sha
			echo "ALL TRANSFERS COMPLETE"
			echo "Please allow several minutes (depending on the size of your dataset) while the data file checksums are verified; once this is completed, the Dataverse UI will be updated"
		fi

                ;;
        "n")
                echo "exiting - please rerun and specify correct directory"
                exit ;;
        *)
                echo "unexpected response - stopping"
                exit ;;
esac

echo "done"
