import cv2
import numpy as np

# Define the input and output video file paths
input_video_path = 'input_video.mp4'
output_video_path = 'output_video.mp4'
weight = 255  # The weight to set if R, G, and B channels are the same

# Open the input video file
cap = cv2.VideoCapture(input_video_path)

# Get video properties
frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
fps = cap.get(cv2.CAP_PROP_FPS)

# Define the codec and create VideoWriter object
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter(output_video_path, fourcc, fps, (frame_width, frame_height))

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # Process the frame
    for y in range(frame_height):
        for x in range(frame_width):
            r, g, b = frame[y, x]
            if r == g == b:
                frame[y, x] = [weight, weight, weight]

    # Write the processed frame to the output video
    out.write(frame)

# Release the video objects
cap.release()
out.release()

print(f"Processed video saved as {output_video_path}")