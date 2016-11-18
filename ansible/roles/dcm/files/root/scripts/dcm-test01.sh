#!/bin/sh

# test script for DCM

# hardcoding localhost, because that's what it's testing

if [ "$1" == "" ]; then
	echo "format is: dcm-test01.sh [test dataset id]"
	exit
fi


curl -H "Content-Type: application/json" -X POST -d "{\"datasetId\":\"${1}\", \"userId\":\"testuser-t03\",\"datasetIdentifier\":\"${1}\"}" http://127.0.0.1/ur.py

