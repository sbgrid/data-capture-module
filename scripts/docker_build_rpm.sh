#!/bin/sh

docker run -it --rm -v `pwd`:/build c6build /build/scripts/build_rpm.sh

