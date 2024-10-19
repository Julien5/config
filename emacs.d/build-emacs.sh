#!/usr/bin/env bash

set -e

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
	rebuild=$1
	shift
	if [ ! -f emacs-29.4.tar.xz ]; then
		wget https://ftp.gnu.org/gnu/emacs/emacs-29.4.tar.xz
	fi
	if [ ! -z ${rebuild} ]; then
		rm -Rf emacs-29.4
	fi
	if [ ! -d emacs-29.4 ]; then	
		tar xvf emacs-29.4.tar.xz
	fi
	rm -Rf /tmp/emacs-bin || true
	cd emacs-29.4
	echo autogen
	./autogen.sh 
	# ./configure --prefix=/tmp/emacs-29-4 --with-x=yes --with-x-toolkit=gtk3 --with-pgtk=no --with-tree-sitter
	echo configure
	./configure \
--build=x86_64-linux-gnu --prefix=/tmp/emacs-bin --disable-maintainer-mode --disable-dependency-tracking --program-suffix=-snapshot --with-modules=yes --with-x=yes --with-x-toolkit=gtk3 --with-pgtk=no
 	
	make -j8
	make install
	# sudo -E make install
}

function main() {
	BUILDDIR=/tmp/buildemacs
	# rm -Rf ${BUILDDIR}
	if [ ! -d ${BUILDDIR} ]; then
		mkdir -p ${BUILDDIR}
		cd ${BUILDDIR}
		sudo apt install build-essential libgtk-3-dev libgnutls28-dev \
			 libtiff5-dev libgif-dev libjpeg-dev libpng-dev \
			 libxpm-dev libncurses-dev texinfo autoconf
		
	fi
	# build-tree-sitter
	sudo ldconfig /usr/local/lib
	cd ${BUILDDIR}
	build-emacs rebuild	
}

main "$@"


###
# "--build=x86_64-linux-gnu --prefix=/usr '--includedir=${prefix}/include' '--mandir=${prefix}/share/man' '--infodir=${prefix}/share/info' --sysconfdir=/etc --localstatedir=/var --disable-silent-rules '--libdir=${prefix}/lib/x86_64-linux-gnu' '--libexecdir=${prefix}/lib/x86_64-linux-gnu' --disable-maintainer-mode --disable-dependency-tracking --prefix=/usr --sharedstatedir=/var/lib --program-suffix=-snapshot --with-modules=yes --with-x=yes --with-x-toolkit=gtk3 --with-xwidgets=yes --with-pgtk=yes 'CFLAGS=-g -O2 -fdebug-prefix-map=/build/emacs-snapshot-KY0yzH/emacs-snapshot-110704=. -fstack-protector-strong -Wformat -Werror=format-security' 'CPPFLAGS=-Wdate-time -D_FORTIFY_SOURCE=2' 'LDFLAGS=-Wl,-Bsymbolic-functions -Wl,-z,relro'"


