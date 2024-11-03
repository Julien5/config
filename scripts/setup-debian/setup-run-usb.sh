#!/usr/bin/env bash

set -e
#set -x

SCRIPTDIR=$(dirname $(realpath $0))

mkdir -p /tmp/X
tar xvf ${SCRIPTDIR}/source.tgz -C /tmp/X
EXE=$(find /tmp/X/ -name "setup-debian.sh")
$EXE
