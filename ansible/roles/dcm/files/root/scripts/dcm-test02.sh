#!/bin/sh

# test script for retrieving upload script (if present)

dset=3

curl -X POST -d "datasetIdentifier=$dset" http://127.0.0.1/sr.py

