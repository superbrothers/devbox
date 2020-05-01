FROM ubuntu:18.04 AS stage-0

# Install build-essential etc
RUN set -x -e && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        apt-utils \
        locales \
        curl \
        file \
        git \
        wget \
        tree \
        zip \
        man \
        sudo && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY etc/apt/apt.conf.d/01norecommend /etc/apt/apt.conf.d/01norecommend

# Create a user
ENV USER=dev
RUN set -x -e && \
    groupadd -g 999 docker && \
    useradd -G docker -m -s /bin/bash "$USER" && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER "$USER"
ENV HOME="/home/$USER"

# Install Linuxbrew
# https://github.com/Homebrew/brew/blob/master/docs/Linuxbrew.md
RUN set -x -e && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" && \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    brew --version && \
    brew update && \
    brew cleanup

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
ENV HOMEBREW_NO_AUTO_UPDATE=1

# Install development packages
COPY Brewfile* /home/linuxbrew/
RUN set -x && \
    brew bundle install --file=/home/linuxbrew/Brewfile && \
    brew cleanup

# Install go tools
ENV GOPATH="/go"
RUN set -x -e && \
    sudo mkdir "$GOPATH" && \
    sudo chown "$USER" "$GOPATH" && \
    export GOCACHE=/tmp && \
    go get github.com/nsf/gocode

ENV PATH="/go/bin:$PATH"

# Set default environment variables
ENV EDITOR=vim
ENV GOPATH="$HOME"
ENV GHQ_ROOT="$HOME/src"
ENV LESSCHARSET=utf-8
