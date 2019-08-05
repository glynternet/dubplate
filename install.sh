#!/bin/bash
usage="$0 appName appRootDir"
appName="${1:?appName not set}"
appRootDir="${2:?appRootDir not set}"

replaceInTmpFiles(){
	local placeholder="${1:?placeholder not set}"
	local replacement="${2:?replacement not set}"
	find "$tmpDir" -type f -not -path '*/\.*' -exec sed -i "s/$placeholder/$replacement/g" {} +
}

tmpDir="$(mktemp --directory --suffix -dubplate)"
cp -vr ./dubplate "$tmpDir"

dubplateVersion="$(make --no-print-directory --directory dubplate --file dubplate.Makefile version)"
echo Dubplate version: "$dubplateVersion"

replaceInTmpFiles whiteplate "$appName"
replaceInTmpFiles {{DUBPLATE_VERSION}} "$dubplateVersion"
