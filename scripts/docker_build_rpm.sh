#!/bin/sh
if [ -z ${DCM_VERSION} ]; then
	DCM_VERSION=0.1
fi

docker run --rm -e DCM_VERSION=${DCM_VERSION} -v `pwd`:/build c6build /build/scripts/build_rpm.sh

