#!/bin/bash
set -e

usage="usage: $0 appRootDir configFile"
appRootDir="${1:?appRootDir not set. $usage}"
configFile="${2:?configFile not set. $usage}"

repository="$(yq -r .repo "$configFile")"
# Check at least one appName is set
appNames="$(yq -r .apps[] "$configFile")"

replacePlaceholdersInDir(){
	local dir="${1:?dir not set}"
	local placeholder="${2:?placeholder not set}"
	local replacement="${3:?replacement not set}"
	find "$dir" -type f -exec sed -i "s|$placeholder|$replacement|g" {} \;
}

generateAppCmdDir() {
	local appName="${1:?appName not set}"
	local appCmdDir="$tmpDir/dubplate/cmd/$appName"
	cp -rv "$tmpWhiteplateDir" "$appCmdDir"
	replacePlaceholdersInDir "$appCmdDir" whiteplate "$appName"
}

tmpDir="$(mktemp --directory --suffix -dubplate)"
tmpWhiteplateDir="$tmpDir/dubplate/cmd/whiteplate"

echo "Copying templates"
cp -vr ./dubplate "$tmpDir"

dubplateVersion="$(make --no-print-directory --directory dubplate --file dubplate.Makefile version)"
echo Dubplate version: "$dubplateVersion"

replacePlaceholdersInDir "$tmpDir" {{DUBPLATE_VERSION}} "$dubplateVersion"
replacePlaceholdersInDir "$tmpDir" {{GO_VERSION}} "1.15.4"
replacePlaceholdersInDir "$tmpDir" {{REPOSITORY}} "$repository"

for appName in $appNames; do
	echo "Generating $appName"
	generateAppCmdDir "$appName"
done

echo "Removing temporary whiteplate files"
rm -rf "$tmpWhiteplateDir"

echo "Moving generated files"
cp -vr "$tmpDir/dubplate/." "$appRootDir/"
