# this is highly experimental, and will almost certainly not work on your system without customization

FROM cent6v-base # Standard CentOS 6 base image (image intentionally not in repos), pick your favorite

RUN yum install -y ansible
ADD . /tmp/dcm
WORKDIR /tmp/dcm/ansible
RUN ansible-playbook -i local.hostlist -c local dcm.yml

EXPOSE 22 80
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

