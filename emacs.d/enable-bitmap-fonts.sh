#!/usr/bin/env bash

mkdir -p /usr/local/share/fonts/bitmaps/
cp config/emacs.d/fonts/*.otb /usr/local/share/fonts/bitmaps/
/sbin/dpkg-reconfigure fontconfig-config
fc-cache -fv /usr/local/share/fonts/bitmaps/
fc-list | grep bitmaps 