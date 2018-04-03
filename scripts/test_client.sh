#!/bin/sh

# argument check
if [ -z "${DCM_HOST}" ]; then
	echo "dcm host unspecified; bailing out"
	exit 1
fi

if [ -z "$1" ]; then
	echo "format is: test_client [test dataset id] [test user id] [test dataset path]"
	exit 1
else
	dset=$1
fi

if [ -z $"$2" ]; then 
	echo "format is: test_client [test dataset id] [test user id] [test dataset path]"
	exit 1
else
	user=$2
fi
if [ -z $"$3" ]; then 
	echo "format is: test_client [test dataset id] [test user id] [test dataset path]"
	exit 1
else
	dpath=$3
fi

curl -H "Content-Type: application/json" -X POST -d "{\"datasetId\":\"${dset}\", \"userId\":\"${user}\",\"datasetIdentifier\":\"${1}\"}" http://${DCM_HOST}/ur.py

sleep 2 #eventually check for non-404 in sr.py call

curl -X POST -d "datasetIdentifier=$dset" http://${DCM_HOST}/sr.py | jq -r .script > ${dset}.bash

bash ./${dset}.bash << eof
${dpath}
y
eof

