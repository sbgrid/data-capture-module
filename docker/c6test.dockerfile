FROM centos:6
RUN yum install -y epel-release
#RUN yum install python python-pip python-dateutil redis lighttpd openssh-server rsync perl-Digest-SHA m4 jq rssh
COPY dcm-0.1-0.noarch.rpm /tmp/
RUN yum localinstall -y /tmp/dcm-0.1-0.noarch.rpm
RUN pip install -r /opt/dcm/requirements.txt
