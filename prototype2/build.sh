#!/bin/bash

if [[ $# -ne 2 || ! $1 || ! $2 ]]; then
    echo "Usage: build.sh [filename] [export_path]"
    exit 1;
fi

if [[ ! -d $2 || ! -w $2 ]]; then
    echo "Path $2 must be a writeable directory."
    exit 2;
fi

echo "Wiping build directory..."
rm -rv ./build

echo "Building and exporting for Windows...";
mkdir -p ./build/windows && godot3 --quiet --export-debug "Windows Desktop" "build/windows/$1.exe" && zip "$2/$1_windows.zip" build/windows/$1.*

echo "Building and exporting for Linux...";
mkdir -p ./build/linux && godot3 --quiet --export-debug "Linux/X11" "build/linux/$1.x86_64" && tar -cvzf "$2/$1_linux.tar.gz" build/linux/$1.*