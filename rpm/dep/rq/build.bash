#!/usr/bin/env bash

rq_version=0.8.1
# TODO - dependency check (python setuptools, yum)
# might also work better in /tmp or other path outside repo
if [ ! -e ../src/rq-${rq_version}.tar.gz ]; then
	wget https://github.com/rq/rq/archive/v${rq_version}.tar.gz -O ../src/rq-${rq_version}.tar.gz
fi
tar zxf ../src/rq-${rq_version}.tar.gz
cd rq-${rq_version}
python setup.py bdist --format=rpm
cp dist/rq-${rq_version}-1.noarch.rpm ../../dist/

