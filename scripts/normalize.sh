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
		# a hack. works only if WPIDs and PIDs have no common element 
		if ps -p $1 &> /dev/null; then
			ps -W | grep $1 | grep emacs | tail -1 | awk -e '/^[[:space:]]+[[:digit:]+]/{print $4}'
		else
			echo $1
		fi
	else
		echo $1
	fi
}
