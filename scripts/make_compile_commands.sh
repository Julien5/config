#!/usr/bin/env bash

source $JULIEN5CONFIGPATH/scripts/normalize.sh

#    ],
#    "directory": "C:/home/jbourgeois/work/projects/desktop/backend/server/example",
#    "file": "C:/home/jbourgeois/work/projects/desktop/backend/server/example/requesthandler.h"
#}

function compile_flags_as_arguments_worker() {
	cat d/compile_flags.txt | while read a; do
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
printf "[\n"
cc_file $(normalize.path $1)
for f in "${@:2:$#}"; do
	printf ",\n"
	cc_file $(normalize.path $f)
done
printf "\n]\n"
