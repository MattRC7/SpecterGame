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

# Set Git Label
label="$major.$minor.$patch"
current_tag=$(git tag --points-at)
if [[ -n "$current_tag" ]]; then
    if [[ $label != "$current_tag" ]]; then
        echo "HEAD is already tagged with version $current_tag";
        exit 4;
    fi
else
    if [[ -n $(git tag -l $label) ]]; then
        echo "Version $label is already set to a different commit."
        exit 4;
    else
        echo "Tagging HEAD with label $label"
        git tag -a -m "$description" "$label" || exit 4;
    fi
fi

export_path=$3
if [[ ! -d $export_path || ! -w $export_path ]]; then
    echo "Path $export_path must be a writeable directory."
    exit 3;
fi

# Create export subdirectory
export_path=${export_path}/${major}_${minor}_${patch}
echo "Creating export subdirectory ${export_path}/${major}_${minor}_${patch}...";
mkdir -vp "$export_path" || exit 5;

# Wipe build directory
if [[ -d ./build ]]; then
    echo "Wiping build directory..."
    rm -rv ./build || exit 5;
    mkdir -vp ./build || exit 5;
fi

filename="${description}_${major}_${minor}_${patch}"
homepath=$(pwd);

printf "\nBuilding and exporting for Windows...\n\n";
mkdir -vp ./build/windows || exit 5;
godot3 --quiet --export-debug "Windows Desktop" "build/windows/$filename.exe" || exit 6;
cd build/windows;
zip "$export_path/${filename}_windows.zip" ./${filename}.* || exit 7;

cd "$homepath"

printf "\nBuilding and exporting for Linux...\n\n";
mkdir -vp ./build/linux || exit 5;
godot3 --quiet --export-debug "Linux/X11" "build/linux/$filename.x86_64" || exit 6;
cd build/linux
tar -cvzf "$export_path/${filename}_linux.tar.gz" ./${filename}.* || exit 7;