# docker run -it --rm -v ${FULL_PATH_REPO_ROOT}:/build c6build bash

# build in ${FULL_PATH_REPO_ROOT}/rpm/deb

FROM centos:6
# starting centos 6 build image for DCM
RUN yum install -y rpm-build python-setuptools wget rpmdevtools
RUN useradd builder
WORKDIR /home/builder
USER builder
RUN cd ~/ ; rpmdev-setuptree
COPY rpmmacros ~/.rpmmacros

