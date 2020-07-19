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
		echo "$@" | sed 's|^/\([a-z,A-Z]\)/|\1:/|';
	else
		echo "$@";
	fi
}

function normalize.path() {
	echo $(winify $(realpath "$@"))
}


function normalize.pid {
	if [[ "$(system)" = "msys"  ]]; then
		ps -p $1 | awk -e '/^[[:space:]]+[[:digit:]+]/{print $4}'
	else
		echo $1
	fi
}
