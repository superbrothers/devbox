FROM ubuntu:18.04

COPY etc/apt/apt.conf.d/01norecommend /etc/apt/apt.conf.d/01norecommend

# Install docker-ce-cli
RUN set -x -e && \
    apt-get update && \
    apt-get -y install gpg-agent apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Create a user
RUN set -x -e && \
    apt-get update && \
    apt-get -y install sudo && \
    groupadd -g 999 docker && \
    useradd -G docker -m -s /bin/bash ksuda && \
    echo "ksuda ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ksuda
