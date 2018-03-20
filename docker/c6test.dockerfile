# build from repo root
FROM centos:6
RUN yum install -y epel-release
COPY dist/dcm-0.1-0.noarch.rpm /tmp/
COPY doc/config/bashrc /root/.bashrc
COPY scripts/test_install.sh /root/
RUN yum localinstall -y /tmp/dcm-0.1-0.noarch.rpm
RUN pip install -r /opt/dcm/requirements.txt
RUN /root/test_install.sh
COPY docker/entrypoint-c6test.sh /
EXPOSE 80
CMD ["/entrypoint-c6test.sh"]
