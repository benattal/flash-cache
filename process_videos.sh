#!/bin/bash

# Directory containing the video files
VIDEO_DIR="supp/videos/"

# Temporary output file
TEMP_OUTPUT="temp_output.mp4"

# Iterate over each file in the directory that ends with _normals.mp4
for input_video in "$VIDEO_DIR"/hotdog*_normals.mp4; do
    # Generate the corresponding mask video path by replacing "normals" with "albedo"
    mask_video="${input_video/_normals.mp4/_relight_2.mp4}"

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

# Iterate over each file in the directory that ends with _normals.mp4
for input_video in "$VIDEO_DIR"/hotdog*_albedo.mp4; do
    # Generate the corresponding mask video path by replacing "normals" with "albedo"
    mask_video="${input_video/_albedo.mp4/_relight_2.mp4}"

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

# Iterate over each file in the directory that ends with _normals.mp4
for input_video in "$VIDEO_DIR"/hotdog*_roughness.mp4; do
    # Generate the corresponding mask video path by replacing "normals" with "roughness"
    mask_video="${input_video/_roughness.mp4/_relight_2.mp4}"

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