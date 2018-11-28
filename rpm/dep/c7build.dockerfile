# docker run -it --rm -v ${FULL_PATH_TO_DEP_DIRECTORY}:/build c7build bash

FROM centos:7
# starting centos 7 build image for DCM
RUN yum install -y rpm-build python-setuptools wget zip
RUN useradd builder

#USER builder

