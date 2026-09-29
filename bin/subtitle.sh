#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Check if a file was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <filename.mkv>"
    exit 1
fi

INPUT_FILE="$1"

# Check if the file actually exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

echo "Processing: $INPUT_FILE"

# 1. Update the language metadata of the first subtitle track to English
echo "Setting first subtitle track language to English..."
mkvpropedit "$INPUT_FILE" --edit track:s1 --set language=eng

# Create a temporary name for the mkvmerge output
TEMP_FILE="temp_merge_output.mkv"

# 2. Extract only subtitle track 2 (and keep all video/audio)
echo "Removing all subtitle tracks except ID 2..."
mkvmerge -o "$TEMP_FILE" --subtitle-tracks 2 "$INPUT_FILE"

# 3. Replace the original file with the newly cleaned file
echo "Overwriting original file with the updated version..."
mv "$TEMP_FILE" "$INPUT_FILE"

echo "Done! Process completed successfully."

