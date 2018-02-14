#!/usr/bin/env bash

# create tarball for building staging/prod rpm

v=0.1

if [ ! -d dist/ ]; then
	mkdir dist
fi

tar zcf dist/dcm-${v}.tar.gz requirements.txt scn/* gen/* api/sr.py api/ur.py
