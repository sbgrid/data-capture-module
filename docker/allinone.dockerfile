# older version with ansible installation procedure (vs rpm installation procedure).
# In other words, you're probably looking for c6test.dockerfile instead
#
# docker file for testing DCM function
# `/sr.py` and `/ur.py` endpoints working; checksum validation and dataverse notification not yet done

FROM centos:6

RUN yum install -y epel-release sudo
RUN yum install -y ansible


ADD . /usr/local/dcm
WORKDIR /usr/local/dcm/ansible
RUN ansible-playbook -i local.hostlist -c local docker.yml
WORKDIR /usr/local/dcm

RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_key
RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -b 1024 -t dsa -f /etc/ssh/ssh_host_dsa_key

EXPOSE 22 80
HEALTHCHECK CMD ./docker/healthcheck.sh

CMD ["./docker/entrypoint-allinone.sh"]

