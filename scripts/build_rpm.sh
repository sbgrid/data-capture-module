#!/bin/sh

if [ -z ${DCM_VERSION} ]; then
	v=0.1
else
	v=${DCM_VERSION}
fi
echo "DCM_VERSION=${DCM_VERSION}"
cp /build/dist/dcm-${v}.tar.gz ~/rpmbuild/SOURCES/
cp /build/rpm/dcm.spec /tmp/
rpmbuild -ba --define "version ${v}" /tmp/dcm.spec
cp ~/rpmbuild/RPMS/noarch/dcm-${v}-0.noarch.rpm /build/dist/
