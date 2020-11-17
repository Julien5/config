#!/usr/bin/env bash

set -e
#set -x

TMP=c:/tmp
OLDNAME=$1
NEWNAME=$2

#N=$(grep -FUbo "$OLDNAME" $FILE | cut -f1 -d":" | wc -l)
#if [[ $N -gt 1 ]]; then
#	echo error
#	exit 1
#fi

#OFFSET=$(grep -FUbo "$OLDNAME" $FILE | cut -f1 -d":" | head -1)
#clang-rename -offset=$OFFSET -new-name=$NEWNAME $FILE


BASENAME=$(echo $OLDNAME | tr ":" "\n" | tail -1)
function filelist() {
	ag -l -cpp $BASENAME | tr -d "\r" | cut -f1 -d: | egrep "(.cpp$|.h$)"
}

rm -Rf $TMP/fixes
mkdir -p $TMP/fixes
n=0
for FILE in $(filelist); do 
	( clang-rename -qualified-name=$OLDNAME -new-name=$NEWNAME $FILE -export-fixes=$TMP/fixes/fix$n.yaml &> $TMP/fixes/$n.out || true ) &
	n=$((n+1))
done
n=$((n-1))

while [[ $(jobs | grep Running | grep clang-rename | wc -l) -gt 0  ]]; do
	printf "%s jobs running\n" $(jobs | grep clang-rename | wc -l)
	sleep 2
done

clang-apply-replacements $TMP/fixes
