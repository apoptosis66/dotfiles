#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

# Check if a file and subtitle track number were provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <filename.mkv> <subtitle_track_#>"
    exit 1
fi

INPUT_FILE="$1"
TRACK_ID="$2"

# Check if the file actually exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# Check if the track ID is a valid integer
if ! [[ "$TRACK_ID" =~ ^[0-9]+$ ]]; then
    echo "Error: Subtitle track number '$TRACK_ID' must be an integer."
    exit 1
fi

echo "Processing: $INPUT_FILE (subtitle track: $TRACK_ID)"

# Create a temporary name for the mkvmerge output
TEMP_FILE="$(dirname "$INPUT_FILE")/temp_merge_output.mkv"

# Clean up temp file on exit if it exists
trap 'rm -f "$TEMP_FILE"' EXIT

# 1. Extract only the specified subtitle track (keep all video/audio),
#    set its language to English, and set it as the default track
echo "Extracting subtitle track ID $TRACK_ID, setting language to English and default track..."
mkvmerge -o "$TEMP_FILE" \
    --subtitle-tracks "$TRACK_ID" \
    --language "$TRACK_ID:eng" \
    --default-track-flag "$TRACK_ID:1" \
    "$INPUT_FILE"

# 2. Replace the original file with the newly cleaned file
echo "Overwriting original file with the updated version..."
mv "$TEMP_FILE" "$INPUT_FILE"

echo "Done! Process completed successfully."

