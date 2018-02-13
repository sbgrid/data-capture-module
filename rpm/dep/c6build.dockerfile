# docker run -it --rm -v ${FULL_PATH_TO_HOME}:/build c6build bash

FROM centos:6
# starting centos 6 build image for DCM
RUN yum install -y rpm-build python-setuptools wget
RUN useradd builder

#USER builder

