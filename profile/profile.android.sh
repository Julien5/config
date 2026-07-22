#!/usr/bin/env bash

function main() {
	export JAVA_HOME=/opt/android-studio/android-studio/jbr
	export PATH=$PATH:${JAVA_HOME}/bin
	export ANDROID_HOME=/opt/android-studio/Android/Sdk
	export PATH=$PATH:${ANDROID_HOME}/platform-tools
	export PATH=$PATH:${ANDROID_HOME}/cmdline-tools/latest/bin/
	export PATH=$PATH:$ANDROID_HOME/emulator
	export ANDROID_AVD_HOME=$HOME/.config/.android/avd
	export GRADLE_USER_HOME=/media/julien/dev/gradle-user-home
}

main
