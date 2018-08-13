#!/usr/bin/env bash

# create tarball for building staging/prod rpm
if [ -z ${DCM_VERSION} ]; then
	v=0.1
else
	v=${DCM_VERSION}
fi

if [ ! -d dist/ ]; then
	mkdir dist
fi

tar zcf dist/dcm-${v}.tar.gz requirements.txt scn/*sh gen/*py gen/*m4 api/sr.py api/ur.py lib/*py doc/config/* requirements.txt
