#!/bin/bash
set -e

usage="usage: $0 appRootDir repo appNames..."
appRootDir="${1:?appRootDir not set. $usage}"
repository="${2:?repository not set. $usage}"
# Check at least one appName is set
appNameCheck="${3:?appNames not set. $usage}"

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
replacePlaceholdersInDir "$tmpDir" {{REPOSITORY}} "$repository"

for appName in "${@:3}"; do
	echo "Generating $appName"
	generateAppCmdDir "$appName"
done

echo "Moving generated files"
cp -vr "$tmpDir/dubplate/." "$appRootDir/"

echo "Removing temporary files"
rm -vrf "$tmpWhiteplateDir"
