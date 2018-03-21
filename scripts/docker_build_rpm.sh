#!/bin/sh

docker run --rm -v `pwd`:/build c6build /build/scripts/build_rpm.sh

