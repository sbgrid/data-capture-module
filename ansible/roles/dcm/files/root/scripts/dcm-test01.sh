#!/bin/sh

# test script for DCM

# hardcoding localhost, because that's what it's testing

if [ -z "$1" ]; then
	echo "format is: dcm-test01.sh [test dataset id] [test user id]"
	exit 1
else
	dset=$1
fi

if [ -z $"$2" ]; then 
	echo "format is: dcm-test01.sh [test dataset id] [test user id]"
	exit 1
else
	user=$2
fi


curl -H "Content-Type: application/json" -X POST -d "{\"datasetId\":\"${dset}\", \"userId\":\"${user}\",\"datasetIdentifier\":\"${1}\"}" http://127.0.0.1/ur.py

