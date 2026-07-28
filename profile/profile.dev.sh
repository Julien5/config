#!/usr/bin/env bash

function dev.rust() {
	local F=$JULIEN5CONFIGPATH/profile/profile.rust.sh
	echo sourcing ${F} 
	. ${F}
	
}
export -f dev.rust

function dev.flutter() {
	local F=$JULIEN5CONFIGPATH/profile/profile.flutter.sh
	echo sourcing ${F}
	. ${F}
	
}
export -f dev.flutter


function dev.android() {
	local F=$JULIEN5CONFIGPATH/profile/profile.android.sh
	echo sourcing ${F}
	. ${F}
	
}
export -f dev.android

function dev.blog() {
	export GEM_HOME="/opt/jekyll/gems"
	echo "loading Ruby Gems from ${GEM_HOME}"
	echo "build: jekyll build"
	export PATH="${GEM_HOME}/bin:$PATH"
}

# ee with tab completion
alias ee='emacsclient'
complete -F _longopt ee

alias oc=$HOME/.opencode/bin/opencode
