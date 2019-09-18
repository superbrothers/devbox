#!/usr/bin/env bash

set -e -o pipefail; [[ -n "$DEBUG" ]] && set -x

packages=(
  vim \
  docker \
  zsh \
  zsh-syntax-highlighting \
  peco \
  go \
  screen \
  jq \
  dep \
  ctags \
  node \
  dive \
)

brew info "${packages[@]}" --json | jq -r '.[] | .name + " " + .versions.stable' >./packages.txt
