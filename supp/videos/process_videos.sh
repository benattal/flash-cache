#!/bin/bash

# Loop through all files that match *_albedo.mp4
for albedo_file in *_albedo.mp4; do
  # Extract the base name (without _albedo.mp4)
  base_name="${albedo_file%_albedo.mp4}"
  
  # Construct the corresponding normals and relight file names
  normals_file="${base_name}_normals.mp4"
  roughness_file="${base_name}_roughness.mp4"

  output_file_normals="${base_name}_normals_new.mp4"
  output_file_roughness="${base_name}_roughness_new.mp4"

  mask_file="${base_name}_mask.mp4"
  
  # Check if the corresponding normals and relight files exist
  if [[ -f "$normals_file" && -f "$albedo_file" ]]; then
    Apply the ffmpeg command

    ffmpeg -i "$albedo_file" -vf "lutrgb=r='if(gt(val,240),255,0)':g='if(gt(val,240),255,0)':b='if(gt(val,240),255,0)'" \
      -c:v libx264 -crf 0 -preset veryslow "$mask_file"

    # ffmpeg -i "$normals_file" -i "$mask_file" -filter_complex \
    # "[1:v][0:v]blend=all_expr='A+lt(A, 20)*B'[output]" \
    # -map "[output]" -c:a copy "$output_file_normals"

    # ffmpeg -i "$roughness_file" -i "$mask_file" -filter_complex \
    # "[1:v][0:v]blend=all_expr='A+lt(A, 20)*B'[output]" \
    # -map "[output]" -c:a copy "$output_file_roughness"
    
    # Move the output file to replace the original normals file
    echo "Processed $albedo_file"
    # mv "$output_file_normals" "$normals_file"
    # mv "$output_file_roughness" "$roughness_file"
    rm "$mask_file"
  else
    echo "Skipping $albedo_file: corresponding normals or relight file not found."
  fi
  exit
done
