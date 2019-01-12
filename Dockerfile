From ubuntu:18.04

ARG USER=ksuda

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
    useradd -G sudo -m -s /bin/bash "${USER}" && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    # Remove note about sudo
    # https://askubuntu.com/questions/22607/remove-note-about-sudo-that-appears-when-opening-the-terminal
    touch "/home/${USER}/.sudo_as_admin_successful"

USER ${USER}
