FROM ubuntu:18.04

# Install build-essential etc
RUN set -x -e && \
    apt-get update && \
    apt-get install -y build-essential apt-utils locales curl file git && \
    locale-gen en_US.UTF-8

COPY etc/apt/apt.conf.d/01norecommend /etc/apt/apt.conf.d/01norecommend

# Create a user
RUN set -x -e && \
    apt-get update && \
    apt-get -y install sudo && \
    groupadd -g 999 docker && \
    useradd -G docker -m -s /bin/bash ksuda && \
    echo "ksuda ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ksuda
ENV USER=ksuda

# Install Linuxbrew
# https://github.com/Homebrew/brew/blob/master/docs/Linuxbrew.md
RUN set -x -e && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# Install development packages
RUN set -x -e && brew install docker
RUN set -x -e && brew install zsh
RUN set -x -e && brew install vim
RUN set -x -e && brew install peco
RUN set -x -e && brew install ghq
RUN set -x -e && brew install go
RUN set -x -e && brew install node
