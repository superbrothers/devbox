#!/usr/bin/env bash

set -e -o pipefail; [[ -n "$DEBUG" ]] && set -x

[[ ! -d "${HOME}/.asdf/installs" ]] && mkdir -p "${HOME}/.asdf/installs"
[[ ! -d "${HOME}/.asdf/shims" ]] && mkdir -p "${HOME}/.asdf/shims"

. "${ASDF_DATA_DIR}/asdf.sh"
# . "${ASDF_DATA_DIR}/completions/asdf.bash"
