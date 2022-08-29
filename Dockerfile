FROM rockylinux:8

LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/docker-rocky-hardened"
LABEL org.opencontainers.image.description="Prehardenend Rocky Linux Docker Container with arm64 and amd64 support"
LABEL org.opencontainers.image.authors="simeononsecurity"

ENV container docker
ENV TERM=xterm
ENV STIG_PATH=/U_RHEL_8_V1R6_STIG_Ansible/rhel8STIG-ansible/roles/rhel8STIG/files/_Red_Hat_Enterprise_Linux_8_STIG_V1R6_Manual-xccdf.xml
ENV XML_PATH=/STIGresults.xml

# Update and Install Supporting Packages
RUN dnf -y update && dnf -y upgrade && dnf -y install git wget curl kmod python3 python3-pip python3-virtualenv systemd at net-tools zip unzip
RUN alternatives --set python /usr/bin/python3
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade setuptools

# Install Ansible
RUN pip3 install ansible
RUN yum -y --nobest install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN yum -y --nobest --skip-broken install ansible

#Setup DoD Ansible Playbook for RHEL8
RUN wget https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_RHEL_8_V1R6_STIG_Ansible.zip
RUN unzip U_RHEL_8_V1R6_STIG_Ansible.zip -d '/U_RHEL_8_V1R6_STIG_Ansible/'
RUN cd /U_RHEL_8_V1R6_STIG_Ansible/ && unzip -d '/U_RHEL_8_V1R6_STIG_Ansible/rhel8STIG-ansible/' rhel8STIG-ansible.zip

#Run konstruktoid.hardening and DoD Rhel 8 Playbook
RUN git clone https://github.com/simeononsecurity/docker-rocky-hardened.git
RUN ls -la
RUN cd /docker-rocky-hardened/ && chmod +x ./dockersetup.sh
RUN cd /docker-rocky-hardened/ && bash ./dockersetup.sh ; exit 0

ENTRYPOINT [ "/bin/bash" ]
