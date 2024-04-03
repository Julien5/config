#!/bin/bash

set -e
# set -x
archive() {
    filename="$1.tgz"
    dir="$HOME/.$1"
    subdir="$1"
    pushd $dir
    find . -name "*~" -delete
    filelist=$(find .);
    for i in "$@"; do
	case $i in
	    --only=*)
		EXTENSION="${i#*=}"
		echo only $EXTENSION
		filelist=$(find . -type f -name "*.$EXTENSION")
		shift # past argument=value
		;;
	    --ignore=*)
		EXTENSION="${i#*=}"
		echo ignore $EXTENSION
		filelist=$(find . -type f -not -name "*.$EXTENSION")
		shift # past argument=value
		;;
	   --default)
		DEFAULT=YES
		shift # past argument with no value
		;;
	    *)
		# unknown option
		;;
	esac
    done
    rm -vf /tmp/$filename
    tar zcvf /tmp/$filename $filelist
    popd
    mkdir -p $subdir
    pushd $subdir
    tar zxf /tmp/$filename
    popd
}

archive xplanet --ignore=jpg
find xplanet -name "*.log" -print -delete 
archive emacs.d --only=el
