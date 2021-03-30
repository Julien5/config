#!/usr/bin/env bash

set -e
# set -x

source $JULIEN5CONFIGPATH/scripts/normalize.sh

#    ],
#    "directory": "C:/home/jbourgeois/work/projects/desktop/backend/server/example",
#    "file": "C:/home/jbourgeois/work/projects/desktop/backend/server/example/requesthandler.h"
#}

PWD=$(basename $(pwd))
COMPILEFLAGS=$(dirname $(realpath $0))/../compile_flags/$PWD.txt

echo using $COMPILEFLAGS

if [ -e d/compile_flags.txt ]; then
	echo
	echo consider cp d/compile_flags.txt $COMPILEFLAGS
	echo and removing d/
	echo
fi

if [ ! -e $COMPILEFLAGS ]; then
	echo could not find file $COMPILEFLAGS
	exit 1
fi

function compile_flags_as_arguments_worker() {
	cat $COMPILEFLAGS | while read a; do
		printf "  "
		if [[ "$a" == *"-I"* ]]; then
			filename=$(echo $a | cut -b3-)
			printf "\"-I%s\",\n" $(normalize.path $filename);
		else
			printf "\"%s\",\n" $a;
		fi
	done
}

CFA=""
function compile_flags_as_arguments() {
	if [[ -z "$CFA" ]]; then
		CFA=$(compile_flags_as_arguments_worker)
	fi
	echo $CFA;
}

function cc_file() {
	printf "{\n"
	printf " \"arguments\": [\n"
	printf "  \"c:/tools/Qt/Tools/mingw730_32/bin/g++\",\n"
	compile_flags_as_arguments
	printf "  \"$1\"\n"
	printf " ],\n"
	printf " \"directory\":\"%s\",\n" "$(normalize.path $(dirname $1))"
	printf " \"file\":\"%s\",\n" "$1"
	printf "}"
}

#  time ~/jbo/bin/^Cke_compile_commands.sh $(find desktop/backend/update/mender-once/  -name "*.cpp" -o -name "*.h") > compile_commands.json

function main() {
	dos2unix $COMPILEFLAGS
	DIR=$1
	if [[ -z $DIR ]]; then
		DIR=.
	fi
	printf "[\n" > compile_commands.json
	NEEDSCOMMA=""
	for a in moc obj bin debug release; do
		echo cleaning $a
		find $DIR -name "$a" -type d -exec rm -Rf "{}" \; || true
	done
	find $DIR  -name "*.cpp" -o -name "*.h" | while read a; do
		printf "including %s\n" $a
		if [[ ! -z "$NEEDSCOMMA" ]]; then
			printf ",\n" >> compile_commands.json
		fi
   		cc_file $(normalize.path $a) >> compile_commands.json
	   	NEEDSCOMMA="1"
	done
	printf "\n]\n" >> compile_commands.json
}

main $1
