#!/usr/bin/env bash

cd ~
rm -f /tmp/source.tgz

for f in /tmp/passwords.csv /tmp/bookmarks.html; do
	while [ ! -f ${f} ]; do
		echo please export from firefox: ${f}
		sleep 1
	done
done
	
tar cvf /tmp/source.tgz .ssh .gitconfig /tmp/passwords.csv /tmp/bookmarks.html projects/config/scripts
