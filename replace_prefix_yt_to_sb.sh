#!/bin/bash
# This script replaces YT prefix with SB in filenames and folder names recursively from the current directory.

find . -depth \
    \( -name 'YT*' \) \
    -print | while read path; do
    base=$(basename "$path")
    dir=$(dirname "$path")
    newbase="SB${base:2}"
    newpath="$dir/$newbase"
    mv "$path" "$newpath"
done

echo "Renaming complete."
