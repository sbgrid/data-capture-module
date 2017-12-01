# this is highly experimental, and will almost certainly not work on your system without customization

FROM centos:6

RUN yum install -y epel-release sudo
RUN yum install -y ansible
#ADD . /tmp/dcm
#WORKDIR /tmp/dcm/ansible
ADD . /usr/local/dcm
WORKDIR /usr/local/dcm/ansible
RUN ansible-playbook -i local.hostlist -c local docker.yml
WORKDIR /usr/local/dcm

RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_key
RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -b 1024 -t dsa -f /etc/ssh/ssh_host_dsa_key

EXPOSE 22 80
#CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
CMD ["./entrypoint-allinone.sh"]

