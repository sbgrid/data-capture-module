# request queue, redis, generator
FROM centos:6
RUN yum install -y redis python-pip python-devel
COPY gen/ /opt/dcm-gen
COPY docker/entry-gen.sh /opt/dcm-gen/
WORKDIR /opt/dcm-gen
VOLUME /deposit
#TODO - health-check for rq/redis?
# needs to create OS accounts, so needs to run as root
CMD ["entry-gen.sh"]

