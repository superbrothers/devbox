# DO NOT EDIT THIS FILE DIRECTLY
# This file is generated by `make Dockerfile`

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

FROM stage-0 AS brew-vim
ENV VERSION 8.1.2150
RUN set -x && brew install vim

FROM stage-0 AS brew-docker
ENV VERSION 19.03.3
RUN set -x && brew install docker

FROM stage-0 AS brew-zsh
ENV VERSION 5.7.1
RUN set -x && brew install zsh

FROM stage-0 AS brew-zsh-syntax-highlighting
ENV VERSION 0.6.0
RUN set -x && brew install zsh-syntax-highlighting

FROM stage-0 AS brew-peco
ENV VERSION 0.5.3
RUN set -x && brew install peco

FROM stage-0 AS brew-go
ENV VERSION 1.13.1
RUN set -x && brew install go

FROM stage-0 AS brew-screen
ENV VERSION 4.7.0
RUN set -x && brew install screen

FROM stage-0 AS brew-jq
ENV VERSION 1.6
RUN set -x && brew install jq

FROM stage-0 AS brew-dep
ENV VERSION 0.5.4
RUN set -x && brew install dep

FROM stage-0 AS brew-ctags
ENV VERSION 5.8
RUN set -x && brew install ctags

FROM stage-0 AS brew-node
ENV VERSION 12.12.0
RUN set -x && brew install node

FROM stage-0 AS brew-dive
ENV VERSION 0.8.1
RUN set -x && brew install dive


# Install go tools
FROM brew-go AS go-tools
ENV GOPATH="/go"
RUN set -x -e && \
    sudo mkdir "$GOPATH" && \
    sudo chown "$USER" "$GOPATH" && \
    export GOCACHE=/tmp && \
    go get github.com/nsf/gocode

FROM stage-0
COPY --from=brew-vim /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-docker /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-zsh /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-zsh-syntax-highlighting /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-peco /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-go /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-screen /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-jq /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-dep /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-ctags /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-node /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=brew-dive /home/linuxbrew/.linuxbrew/ /home/linuxbrew/.linuxbrew/
COPY --from=go-tools /go/ /go/
ENV PATH="/go/bin:$PATH"

# Set default environment variables
ENV EDITOR=vim
ENV GOPATH="$HOME"
ENV GHQ_ROOT="$HOME/src"
ENV LESSCHARSET=utf-8
