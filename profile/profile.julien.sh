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

# ee with tab completion
alias ee='emacsclient'
complete -F _longopt ee

alias oc=$HOME/.opencode/bin/opencode

function jbo-copy() {
	xclip -selection c -i
}

function md-to-pdf() {
  if [ $# -lt 1 ]; then
    echo "Usage: md-to-pdf <input.md> [output.pdf] [font_name] [extra pandoc args...]"
    return 1
  fi

  local input_file="$1"
  local output_file="${2:-${input_file%.*}.pdf}"
  local font="${3:-Liberation Serif}"

  # Shift off the first 3 positional parameters (if provided)
  # so any extra arguments pass through directly to pandoc
  shift 3 2>/dev/null || shift $#

  /opt/pandoc/pandoc-3.1.11/bin/pandoc "$input_file" \
    --pdf-engine=/opt/typst/typst-x86_64-unknown-linux-musl/typst \
    -V mainfont="$font" \
    -o "$output_file" \
    "$@"
}
