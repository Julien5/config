#!/usr/bin/env bash

function build-tree-sitter() {
	if [ ! -d tree-sitter ]; then
		git clone https://github.com/tree-sitter/tree-sitter
	fi
	pushd tree-sitter
	#git checkout v0.23.0
	git checkout master
	make 
	sudo make install
	popd
}

function build-emacs() {
	if [ ! -f emacs-29.4.tar.xz ]; then
		wget https://ftp.gnu.org/gnu/emacs/emacs-29.4.tar.xz
	fi
	if [ ! -d emacs-29.4 ]; then	
		tar xvf emacs-29.4.tar.xz
	fi
	cd emacs-29.4
	autogen.sh
	./configure \
		--prefix=/usr/local/emacs-29-4-a \
		--with-x-toolkit=gtk3 \
		--with-pgtk=no \
		--with-tree-sitter 	
	make -j8
	sudo -E make install
}

function main() {
	BUILDDIR=/tmp/buildemacs
	rm -Rf ${BUILDDIR}
	if [ ! -d ${BUILDDIR} ]; then
		mkdir -p ${BUILDDIR}
		cd ${BUILDDIR}
		sudo apt install build-essential libgtk-3-dev libgnutls28-dev \
			 libtiff5-dev libgif-dev libjpeg-dev libpng-dev \
			 libxpm-dev libncurses-dev texinfo
		
	fi
	build-tree-sitter
	sudo ldconfig /usr/local/lib
	cd ${BUILDDIR}
	build-emacs	
}

main "$@"
