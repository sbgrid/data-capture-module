#!/bin/sh

# test script for retrieving upload script (if present)

if [ -z "${DCM_HOST}" ]; then
	DCM_HOST=localhost
fi

dset=$1

if [ -z "${dset}" ]; then
	echo "format is: dcm-test02.sh [dataset]"
	exit 1
fi

curl -X POST -d "datasetIdentifier=$dset" http://${DCM_HOST}/sr.py

