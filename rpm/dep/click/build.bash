#!/usr/bin/env bash

click_version=6.7
# TODO - dependency check (python setuptools, yum)
# might also work better in /tmp or other path outside repo
if [ ! -e ../src/rq-${click_version}.tar.gz ]; then
	wget https://github.com/pallets/click/archive/${click_version}.tar.gz -O ../src/click-${click_version}.tar.gz
fi
tar zxf ../src/click-${click_version}.tar.gz
cd click-${click_version}
python setup.py bdist --format=rpm
cp dist/click-${click_version}-1.noarch.rpm ../../dist/

