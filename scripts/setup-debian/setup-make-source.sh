#!/usr/bin/env bash

set -e
#set -x

SCRIPTDIR=$(dirname $(realpath $0))
REPODIR=$(git rev-parse --show-toplevel)

function firefox() {
	for f in /tmp/passwords.csv /tmp/bookmarks.html; do
		while [ ! -f ${f} ]; do
			echo please export from firefox: ${f}
			sleep 1
		done
	done
}

# candidate: $HOME/.ssh
# candidate: $HOME/.gitconfig
# candidate: /tmp/passwords.csv
# candidate: /tmp/bookmarks.html
# candidate: $REPODIR/scripts/setup-debian
# candidate: $HOME/voyages
# candidate: $HOME/tracks
# candidate: $HOME/tours

function candidates() {
	cat $0 | grep "^# candidate:" | cut -f2 -d: | tr -d " " | while read a; do
		if [[ "${a}" == *"\$HOME"* ]]; then
			echo ${a/\$HOME/$HOME}
		elif [[ "${a}" == *"\$REPODIR"* ]]; then
			echo ${a/\$REPODIR/$REPODIR}
		else
			echo ${a}
		fi
	done
}

function make-source() {
	rm -f /tmp/source.tgz
	SOURCES=
	for rc in $(candidates); do
		if [ -e "${rc}" ]; then
			SOURCES="$SOURCES ${rc}"
		else
			echo skip: ${rc}
		fi
	done
	
	tar cvf /tmp/source.tgz ${SOURCES}
}

function copy-usb() {
	USB=$(find /media/julien -mindepth 1 -maxdepth 1 -type d)
	#USB=/media/julien/shares/shared-e
	if [ ! -z $USB ]; then
		cp -v /tmp/source.tgz ${USB};
		cp -v ${REPODIR}/scripts/setup-debian/setup-run-usb.sh ${USB}
		umount $USB || true
	fi
}

function main() {
	firefox
	make-source
	copy-usb
}

main "$@"
echo OK
