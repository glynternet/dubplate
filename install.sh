#!/bin/bash
set -e

usage="usage: $0 appName appRootDir repo"
appName="${1:?appName not set. $usage}"
appRootDir="${2:?appRootDir not set\n$usage}"
repository="${3:?repository not set\n$usage}"

replaceInAppFiles(){
	local appName="${1:?appName not set}"
	local placeholder="${2:?placeholder not set}"
	local replacement="${3:?replacement not set}"
	find "$tmpDir" -type f -exec sed -i "s|$placeholder|$replacement|g" {} +
}

tmpDir="$(mktemp --directory --suffix -dubplate)"
cp -vr ./dubplate "$tmpDir"

dubplateVersion="$(make --no-print-directory --directory dubplate --file dubplate.Makefile version)"
echo Dubplate version: "$dubplateVersion"

tmpWhiteplateDir="$tmpDir/dubplate/cmd/whiteplate"
cp -rv "$tmpWhiteplateDir" "$tmpDir/dubplate/cmd/$appName"
replaceInAppFiles "$appName" whiteplate "$appName"
replaceInAppFiles "$appName" {{DUBPLATE_VERSION}} "$dubplateVersion"
replaceInAppFiles "$appName" {{REPOSITORY}} "$repository"

rm -rf "$tmpWhiteplateDir"

cp -vr "$tmpDir/dubplate/." "$appRootDir/"
