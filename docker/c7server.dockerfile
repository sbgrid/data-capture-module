# build from repo root
FROM centos:7
ARG RPMFILE=dcm-0.1-0.noarch.rpm
RUN yum install -y epel-release
#COPY dist/dcm-0.1-0.noarch.rpm /tmp/
COPY dist/${RPMFILE} /tmp/
COPY doc/config/bashrc /root/.bashrc
COPY scripts/test_install.sh /root/
#RUN yum localinstall -y /tmp/dcm-0.1-0.noarch.rpm
RUN yum localinstall -y /tmp/${RPMFILE}
RUN pip install -r /opt/dcm/requirements.txt
RUN /root/test_install.sh
RUN useradd glassfish
COPY docker/entrypoint-c7server.sh /
EXPOSE 80
EXPOSE 22
CMD ["/entrypoint-c7server.sh"]
