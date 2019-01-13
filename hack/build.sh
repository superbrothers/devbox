#!/bin/sh

set -x -e -o pipefail

apk add make
make image
