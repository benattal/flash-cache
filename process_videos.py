import cv2
import numpy as np
import argparse
import os
import shutil
import subprocess
import tempfile

# Set up argument parser
parser = argparse.ArgumentParser(description='Process a video file.')
parser.add_argument('input_video_path', type=str, help='Path to the input video file')
parser.add_argument('mask_video_path', type=str, help='Path to the mask video file')
parser.add_argument('output_video_path', type=str, help='Path to the output video file')
args = parser.parse_args()

# Define the input and output video file paths
input_video_path = args.input_video_path
mask_video_path = args.mask_video_path
output_video_path = args.output_video_path
white_color = [255, 255, 255]  # The color to set when mask value is 1

# Open the input video file
cap = cv2.VideoCapture(input_video_path)
if not cap.isOpened():
    print(f"Error: Could not open input video file {input_video_path}")
    exit(1)

# Open the mask video file
mask_cap = cv2.VideoCapture(mask_video_path)
if not mask_cap.isOpened():
    print(f"Error: Could not open mask video file {mask_video_path}")
    exit(1)

# Get video properties
frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
fps = cap.get(cv2.CAP_PROP_FPS)
if fps == 0:
    print("Error: Could not retrieve FPS from the video file")
    exit(1)

# Create a temporary directory to store frames
temp_dir = tempfile.mkdtemp()

frame_count = 0
while cap.isOpened() and mask_cap.isOpened():
    ret, frame = cap.read()
    ret_mask, mask_frame = mask_cap.read()
    if not ret or not ret_mask:
        break

    # Ensure the mask is a single channel (grayscale)
    if len(mask_frame.shape) == 3:
        mask_frame = cv2.cvtColor(mask_frame, cv2.COLOR_BGR2GRAY)

    # Vectorized processing of the frame
    mask = ((mask_frame > 240) & np.all(np.abs(frame - np.mean(frame, axis=-1, keepdims=True)) < 10, axis=-1))
    frame[mask] = white_color

    # Write the frame to the temporary directory
    frame_filename = os.path.join(temp_dir, f"frame_{frame_count:06d}.png")
    cv2.imwrite(frame_filename, frame)
    frame_count += 1

# Release the video capture objects
cap.release()
mask_cap.release()

# Use ffmpeg to create the output video from the frames
ffmpeg_command = [
    'ffmpeg',
    '-framerate', str(fps),
    '-i', os.path.join(temp_dir, 'frame_%06d.png'),
    '-c:v', 'libx264',
    '-pix_fmt', 'yuv420p',
    output_video_path
]

subprocess.run(ffmpeg_command)

# Delete the temporary directory and its contents
shutil.rmtree(temp_dir)

print(f"Output video saved to {output_video_path}")