#!/bin/bash

alias testify="go test -testify.m"

# Run tests with coverage and create a colorized report
function gocover() {
    local t=$(mktemp -t coverXXXX)
    go test $COVERFLAGS -coverprofile=$t $@ \
        && go tool cover -func=$t | cRed '\s[0-9]\.?[0-9]?\%' | cLightRed '[1-5][0-9]\.[0-9]\%' | cLightGreen '[6-9][0-9]\.[0-9]\%'| cGreen '9[0-9]\.[0-9]\%' | cGreen '100\.?0?\%' 
    unlink $t   
}

function gotest() {
	#SUITE="$1"
	#if [[ -z "$SUITE" ]]; then
	#	shift 1;
	#fi
	local SUITE=""
	local NOCACHE=""
	local VERBOSE="-v"
	for i in "$@"; do
		case "$i" in
		-n|--no-cache)
			NOCACHE="-count=1"
			shift
			;;
		-q|--quite)
			VERBOSE=""
			shift
			;;
		*)
			SUITE="-run=$i"
			shift
			;;
		esac
	done
	go test $SUITE $NOCACHE $VERBOSE $@ | cGreen "--- PASS:" | cRed "--- FAIL:" | cBold "--- PASS:" | cBold "--- FAIL:" | removeline "=== (RUN\|CONT\|PAUSE).*"
	if [[ "$?" == "0" ]]; then
		echo "All tests passed" | cGreen ".*" | cBold ".*"
	else
		echo "One or more tests have failed" | cRed ".*" | cBold ".*"
	fi

}

function goint() {
	gotest Integration $@
}

function gounit() {
	gotest Unit $@
}
