#!/bin/sh

v=0.1

cp /build/dist/dcm-${v}.tar.gz ~/rpmbuild/SOURCES/
cp /build/rpm/dcm.spec /tmp/
rpmbuild -ba /tmp/dcm.spec
#cp ~/rpmbuild/RPMS/noarch/dcm-${v}-0.noarch.rpm /build/dist/
