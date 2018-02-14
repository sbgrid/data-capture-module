#!/usr/bin/env bash
pkg=redis-py
version=2.10.6
# TODO - dependency check (python setuptools, yum)
# might also work better in /tmp or other path outside repo
if [ ! -e ../src/${pkg}-${version}.tar.gz ]; then
	wget https://github.com/andymccurdy/redis-py/archive/${version}.tar.gz -O ../src/${pkg}-${version}.tar.gz
fi
tar zxf ../src/${pkg}-${version}.tar.gz
cd ${pkg}-${version}
python setup.py bdist --format=rpm
#cp dist/${pkg}-${version}-1.noarch.rpm ../../dist/
cp dist/redis-${version}-1.noarch.rpm ../../dist/${pkg}-${version}-1.noarch.rpm

