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
	local SRC=$(find /tmp/X/ -name .ssh)
	while [ ! -d ${X} ]; do
		echo "copy .ssh directory under ${SRC}"
		sleep 1
		echo 
	done
	# best guess
	# https://unix.stackexchange.com/questions/257590/ssh-key-permissions-chmod-settings
	mkdir -p ~/.ssh/
	cp -Rf ${SRC}/* ~/.ssh/
	find ~/.ssh -type f -name "id_*" -print -exec chmod 600 "{}" \;
	chmod 700 ~/.ssh 
}

function clone-projects() {
	eval $(ssh-agent)
	ssh-add -D
	if [ -f $HOME/.ssh/github-julien5/id_ed25519 ]; then
		ssh-add $HOME/.ssh/github-julien5/id_ed25519
	else
		ssh-add $HOME/.ssh/id_rsa
	fi
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

function install-emacs() {
	surun install-local-emacs
	D=$HOME/.local/share/applications; 
	mkdir -p ${D}; 
	cp -v $HOME/projects/config/emacs.d/emacs.desktop ${D}
	ln -s $HOME/projects/config/emacs.d ~/.emacs.d
}

function main() {
	base-packages	
	# get-source
	install-ssh-keys
	clone-projects
	fonts
	import-bookmarks
	install-emacs
}

cd $SCRIPTDIR
main "$@"
