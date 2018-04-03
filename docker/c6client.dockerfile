# build from repo root
FROM centos:6
RUN yum install -y epel-release
RUN yum install -y rsync openssh-clients jq
RUN useradd depositor
USER depositor
WORKDIR /home/depositor
RUN mkdir dataset scripts
COPY doc/testdata/random/d*.dat dataset/
COPY ansible/roles/dcm/files/root/scripts/dcm-test*sh scripts/
COPY scripts/test_client.sh scripts/
