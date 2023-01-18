#!/usr/bin/env bash

set -e
#set -x

echo use projectile-replace for macros.

TMP=/tmp
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

function hashfind() {
	if hash $1 &> /dev/null; then
		echo $1
		return 0;
	fi
	return 1;
}

function fixversion() {
	if hashfind $1-12; then
		return;
	fi
	if hashfind $1-11; then
		return;
	fi
	if hashfind $1; then
		return
	fi
	echo no $1 found
}
	

function clang_rename() {
	fixversion clang-rename
}

function clang_apply_replacements() {
	fixversion clang-apply-replacements "$@"
}

rm -Rf $TMP/fixes
mkdir -p $TMP/fixes
n=0
for FILE in $(filelist); do
	echo processing $FILE
	CLANGRENAME=$(clang_rename)
	echo cmd: "$CLANGRENAME -qualified-name=$OLDNAME -new-name=$NEWNAME $FILE -export-fixes=$TMP/fixes/fix$n.yaml"
	($CLANGRENAME -qualified-name=$OLDNAME -new-name=$NEWNAME $FILE -export-fixes=$TMP/fixes/fix$n.yaml &> $TMP/fixes/$n.out || true ) &
	n=$((n+1))
done

n=$((n-1))
jobs
while [[ $(jobs | grep Running | grep -i CLANGRENAME | wc -l) -gt 0  ]]; do
	printf "%s jobs running\n" $(jobs | grep CLANGRENAME | wc -l)
	sleep 2
done

echo affected files:
grep FilePath $TMP/fixes/*.yaml | sort | uniq

echo "execute changes? type yes"
read ok
if [[ $ok = "yes" ]]; then
	echo applying changes..
	$(clang_apply_replacements) $TMP/fixes
fi
