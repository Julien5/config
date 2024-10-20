#!/usr/bin/env bash

SCRIPTDIR=$(dirname $(realpath $0))

mkdir -p /tmp/X
tar xvf ${SCRIPTDIR}/source.tgz -C /tmp/X
/tmp/X/projects/config/scripts/setup-debian/setup-debian.sh
