# Buiding a DCM RPM

If you want to build a DCM RPM, the example jenkins job should produce one.
If you don't have the jenkins pipeline setup, you can use to build the rpm (which simplifies building RPMs on OS X).

 1. specify the version to produce (assuming bash shell): `export DCM_VERSION=0.0`
 1. build docker image to use for building the RPM: `docker build -t c6build -f rpm/dep/c6build.dockerfile rpm/dep/`
 1. build tarball: `./scripts/tarball.bash` (will produce `dist/dcm-${DCM_VERSION}.tgz`)
 1. build rpm: `./scripts/docker_build_rpm.sh` (will produce `dist/dcm-${DCM_VERSION}-0.noarch.rpm`)
