#!/bin/bash
set -e

usage="usage: $0 appName appRootDir repo"
appName="${1:?appName not set. $usage}"
appRootDir="${2:?appRootDir not set\n$usage}"
repository="${3:?repository not set\n$usage}"

replaceInTmpFiles(){
	local placeholder="${1:?placeholder not set}"
	local replacement="${2:?replacement not set}"
	find "$tmpDir" -type f -exec sed -i "s|$placeholder|$replacement|g" {} +
}

tmpDir="$(mktemp --directory --suffix -dubplate)"
cp -vr ./dubplate "$tmpDir"

dubplateVersion="$(make --no-print-directory --directory dubplate --file dubplate.Makefile version)"
echo Dubplate version: "$dubplateVersion"

replaceInTmpFiles whiteplate "$appName"
replaceInTmpFiles {{DUBPLATE_VERSION}} "$dubplateVersion"
replaceInTmpFiles {{REPOSITORY}} "$repository"
mv -v "$tmpDir/dubplate/cmd/whiteplate" "$tmpDir/dubplate/cmd/$appName"

cp -vr "$tmpDir/dubplate/." "$appRootDir/"
