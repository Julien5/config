#!/usr/bin/env bash

function system()
{
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        echo "linux";
    else
        if [[ "$OSTYPE" == "msys" ]]; then
            echo "msys";
        else
            echo "unknown";
        fi;
    fi
}

function winify() {
	if [[ "$(system)" = "msys"  ]]; then
		cygpath.exe -m "$@"
		#echo "$@" | sed 's|^/\([a-z,A-Z]\)/|\1:/|';
	else
		echo "$@";
	fi
}

function normalize.path() {
	echo $(winify $(realpath "$@"))
}


