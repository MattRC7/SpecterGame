#!/bin/bash

if [[ $# -ne 3 || ! $1 || ! $2 || ! $3 ]]; then
    echo "Usage: build.sh [description] [version] [export_path]"
    exit 1;
fi

description=$1

IFS='.' read -ra versions <<< "$2"
major=${versions[0]}
minor=${versions[1]}
patch=${versions[2]}
if [[ ! -n $major || ! -n $minor  || ! -n $patch ]]; then
    echo "version must be in the form [major].[minor].[patch]";
    exit 2;
fi

export_path=$3
if [[ ! -d $export_path || ! -w $export_path ]]; then
    echo "Path $export_path must be a writeable directory."
    exit 3;
fi

label="$major.$minor.$patch"
echo "Tagging HEAD with label $label"
git tag -a -m "$description" "$label" || exit 4;

echo "Wiping build directory..."
rm -rv ./build

filename="${description}_${major}_${minor}_${patch}"

echo "Building and exporting for Windows...";
mkdir -p ./build/windows \
&& godot3 --quiet --export-debug "Windows Desktop" "build/windows/$filename.exe" \
&& zip "$export_path/${filename}_windows.zip" build/windows/${filename}.*

echo "Building and exporting for Linux...";
mkdir -p ./build/linux \
&& godot3 --quiet --export-debug "Linux/X11" "build/linux/$filename.x86_64" \
&& tar -cvzf "$export_path/${filename}_linux.tar.gz" build/linux/${filename}.*