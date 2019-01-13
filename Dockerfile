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
ENV HOME="/home/$USER"

# Install Linuxbrew
# https://github.com/Homebrew/brew/blob/master/docs/Linuxbrew.md
RUN set -x -e && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" && \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    brew --version && \
    brew update

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# Install development packages
ARG HOMEBREW_NO_AUTO_UPDATE=1
RUN set -x && brew install docker
RUN set -x && brew install zsh
RUN set -x && brew install vim
RUN set -x && brew install peco
RUN set -x && brew install ghq
RUN set -x && brew install go
RUN set -x && brew install node
RUN set -x && brew install screen
RUN set -x && brew install jq
RUN set -x && brew install dep

# Install go tools
ENV GOPATH="/go"
RUN set -x -e && \
    sudo mkdir "$GOPATH" && \
    sudo chown "$USER" "$GOPATH" && \
    export GOCACHE=/tmp/gocache && \
    go get github.com/nsf/gocode && \
    rm -rf "$GOPATH/src" "$GOCACHE"

ENV PATH="$GOPATH/bin:$PATH"

# Set default environment variables
ENV EDITOR=vim
ENV GOPATH="$HOME"
ENV GHQ_ROOT="$HOME/src"
