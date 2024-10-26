#!/usr/bin/env bash

set -e
# set -x

SCRIPTDIR="$(dirname $(realpath "$0"))"

# substitute for sudo
function surun() {
	ROOTEXE=$SCRIPTDIR/setup-debian-root.sh
	su root $ROOTEXE "$@"
}

function install-ssh-keys() {
	if [ -d ~/.ssh ]; then
		echo ssh directory is done
		return
	fi
	local SRC=/tmp/X/.ssh
	while [ ! -d ${X} ]; do
		echo "copy .ssh directory under ${SRC}"
		sleep 1
		echo 
	done
	# best guess
	# https://unix.stackexchange.com/questions/257590/ssh-key-permissions-chmod-settings
	mkdir ~/.ssh/
	cp -Rf ${SRC}/* ~/.ssh/
	chmod 600 ~/.ssh/id_rsa
	chmod 600 ~/.ssh/id_rsa.pub
	chmod 700 ~/.ssh 
}

function clone-projects() {
	mkdir -p ~/projects
	cd ~/projects/
	for a in config sandbox private; do
		if [ -d ${a} ]; then
			echo found git project ${a}
			continue
		fi
		git clone git@github.com:Julien5/${a}.git
		# git clone https://github.com/Julien5/${a}.git
		# pushd ${a}
		# note: fix origin for https -> ssh git push
		# git remote set-url origin git@github.com:Julien5/${a}.git
		#popd
	done
}

function get-source() {
	if [ -f /tmp/source.tgz ]; then
		echo found /tmp/source.tgz
		return 
	fi
	set -x
	scp ${SCRIPTDIR}/setup-make-source.sh julien@thinkpad:/tmp/
	ssh julien@thinkpad "/tmp/setup-make-source.sh"
	scp julien@thinkpad:/tmp/source.tgz /tmp/
	set +x
	mkdir -p /tmp/setup-source
	cd /tmp/setup-source
	tar xvf /tmp/source.tgz
}

function import-bookmarks() {
	echo open firefox and:
	echo " * import /tmp/setup-source/tmp/passwords.csv"
	echo " * import /tmp/setup-source/tmp/bookmarks.html" 
}

function build-emacs() {
	cd ~/projects/config/emacs.d/
}

function base-packages() {
	if ! hash git; then
		surun install-packages
		return;
	fi
	echo base packages are installed
}

function fonts() {
	if [ ! -d /usr/local/share/fonts/bitmaps/ ]; then
		surun install-bitmap-fonts
	fi
	echo fonts are installed
}

function main() {
	base-packages	
	# get-source
	install-ssh-keys
	clone-projects
	fonts
	import-bookmarks
	echo todo build-emacs
}

cd $SCRIPTDIR
main "$@"
