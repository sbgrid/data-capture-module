# docker run -it --rm -v ${FULL_PATH_REPO_ROOT}:/build c6build bash

# build in ${FULL_PATH_REPO_ROOT}/rpm/dep

FROM centos:6
# starting centos 6 build image for DCM
RUN yum install -y rpm-build python-setuptools wget rpmdevtools

# need to match the jenkins uid/gid for this to work properly.
# FIXME - this shouldn't be hard-coded
RUN groupadd builder -g 116
RUN useradd builder -u 110 -g 116
WORKDIR /home/builder
USER builder
RUN cd ~/ ; rpmdev-setuptree
COPY rpmmacros ~/.rpmmacros

