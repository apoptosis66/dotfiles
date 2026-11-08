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

# Create temporary names for the mkvmerge and ffmpeg outputs
TEMP_FILE="$(dirname "$INPUT_FILE")/temp_merge_output.mkv"
TEMP_AUDIO_FILE="$(dirname "$INPUT_FILE")/temp_audio_output.mkv"

# Clean up temp files on exit if they exist
trap 'rm -f "$TEMP_FILE" "$TEMP_AUDIO_FILE"' EXIT

# 1. Extract only the specified subtitle track (keep all video/audio),
#    set its language to English, and set it as the default track
echo "Extracting subtitle track ID $TRACK_ID, setting language to English and default track..."
mkvmerge -o "$TEMP_FILE" \
    --subtitle-tracks "$TRACK_ID" \
    --language "$TRACK_ID:eng" \
    --default-track-flag "$TRACK_ID:1" \
    "$INPUT_FILE"

# 2. Convert any AC3/EAC3 audio tracks to AAC (Chromecast can't play them).
#    All other streams (video, subtitles, other audio, chapters, attachments)
#    are copied untouched. Channel count is preserved at ~64 kbps per channel.
# AUDIO_ARGS=()
# AUDIO_IDX=0
# NEEDS_CONVERT=0
# while IFS=, read -r CODEC CHANNELS; do
#     if [[ "$CODEC" == "ac3" || "$CODEC" == "eac3" ]]; then
#         CHANNELS="${CHANNELS:-2}"
#         BITRATE="$(( CHANNELS * 64 ))k"
#         echo "Audio track $AUDIO_IDX is $CODEC (${CHANNELS}ch), converting to AAC @ $BITRATE..."
#         AUDIO_ARGS+=(-c:a:"$AUDIO_IDX" aac -b:a:"$AUDIO_IDX" "$BITRATE")
#         NEEDS_CONVERT=1
#     else
#         AUDIO_ARGS+=(-c:a:"$AUDIO_IDX" copy)
#     fi
#     AUDIO_IDX=$(( AUDIO_IDX + 1 ))
# done < <(ffprobe -v error -select_streams a \
#     -show_entries stream=codec_name,channels -of csv=p=0 "$TEMP_FILE")
#
# if [ "$NEEDS_CONVERT" -eq 1 ]; then
#     ffmpeg -hide_banner -loglevel warning -stats -y \
#         -i "$TEMP_FILE" \
#         -map 0 -c:v copy -c:s copy -c:t copy -c:d copy \
#         "${AUDIO_ARGS[@]}" \
#         "$TEMP_AUDIO_FILE"
#     mv "$TEMP_AUDIO_FILE" "$TEMP_FILE"
# else
#     echo "No AC3/EAC3 audio found, leaving audio untouched."
# fi

# 3. Replace the original file with the newly cleaned file
echo "Overwriting original file with the updated version..."
mv "$TEMP_FILE" "$INPUT_FILE"

echo "Done! Process completed successfully."
