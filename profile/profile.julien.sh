#!/usr/bin/env bash

function open-notes() {
	$JULIEN5CONFIGPATH/../private-notes/blog/open.sh
}

function copy() {
	xclip -selection c
}

function mount-android() {
	# try `-android=0` if it fails with sony xperia.
	local DIRNAME=/tmp/android-pixel-mount
	mkdir -p ${DIRNAME}
	umount ${DIRNAME} || true
	echo mounting...
	go-mtpfs ${DIRNAME} &
	sleep 1
	if ! grep -qs "${DIRNAME} " /proc/mounts &> /dev/null; then
		echo "failed to mount ${DIRNAME}"
		echo "check:"
		echo "    - lsusb"
		return 1
	fi
	if ! find ${DIRNAME}  -mindepth 1 -maxdepth 1 &> /dev/null; then
		echo "mounted ${DIRNAME} but failed to read."
		echo "maybe access to device is not granted"
		return 1
	fi
	W=$(find ${DIRNAME}  -mindepth 1 -maxdepth 1)
	if [ -z ${W} ]; then
		echo "mounted ${DIRNAME} but failed to read any file."
		echo "maybe access to device is not granted"
		return 1
	fi
	xdg-open ${DIRNAME}
}
