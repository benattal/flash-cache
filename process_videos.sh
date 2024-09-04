#!/bin/bash

# Directory containing the video files
VIDEO_DIR="videos/"

# Temporary output file
TEMP_OUTPUT="temp_output.mp4"

# Iterate over each file in the directory that ends with _normals.mp4
for input_video in "$VIDEO_DIR"/*_normals.mp4; do
    # Generate the corresponding mask video path
    mask_video="${input_video/_normals.mp4/_mask.mp4}"

    # Check if the mask video exists
    if [[ -f "$mask_video" ]]; then
        # Run the process_videos.py script
        python process_videos.py "$input_video" "$mask_video" "$TEMP_OUTPUT"

        # Replace the original video with the processed output
        mv "$TEMP_OUTPUT" "$input_video"
    else
        echo "Mask video not found for $input_video"
    fi
done