'''
VIDEO_DETECT - This script performs object tracking on a video file using the YOLOv8 model.

It reads a video, applies the YOLOv8 model to detect and track all objects in each frame,
saves a video with tracking annotations, and saves the raw tracking data to a .mat file.
This video can be used to visually identify the track IDs of interest for further analysis.

Configuration is loaded from 'config.json'.

Inputs:
    - A video file (path specified in config.json).
    - YOLOv8 model file ('yolov8n.pt').

Outputs:
    - An AVI video file with tracking annotations for all detected objects.
    - A .mat file with the raw, unscaled tracking data for all objects.

Author: Tiago Simões
Project: VIENA
Instituto Superior Técnico
October 2024; Last revision: 21-September-2025
''' 
#------------- BEGIN MAIN FUNCTION ---------------

import cv2
from ultralytics import YOLO
from collections import defaultdict
import numpy as np
from scipy.io import savemat
import json
import os

def get_unique_filepath(filepath):
    """
    Checks if a file exists and returns a unique filepath with a numeric suffix if it does.
    """
    if not os.path.exists(filepath):
        return filepath

    directory, filename = os.path.split(filepath)
    name, ext = os.path.splitext(filename)
    counter = 1
    while True:
        new_name = f"{name}_{counter}{ext}"
        new_filepath = os.path.join(directory, new_name)
        if not os.path.exists(new_filepath):
            return new_filepath
        counter += 1

# Load configuration from config.json
with open('config.json', 'r') as f:
    config = json.load(f)['video_track']

# Get parameters from config
track_height = config['track_height']
save_status = config['save']
show_status = config['show']

# Determine the video path
video_name = config['video_path']
if os.path.exists(video_name):
    video_path = video_name
else:
    print(f"Error: Video file '{video_name}' not found.")
    exit()

# Capture video from a file
vid_cap = cv2.VideoCapture(video_path)

# Initialize video writer and data paths if save_status is true
vid_save = None
output_raw_data_path = None
if save_status:
    # Video output
    output_video_path_from_config = config['output_video_path']
    output_dir_vid = os.path.dirname(output_video_path_from_config)
    if not os.path.exists(output_dir_vid):
        os.makedirs(output_dir_vid)

    frame_width = int(vid_cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    frame_height = int(vid_cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    fps = vid_cap.get(cv2.CAP_PROP_FPS)
    unique_output_video_path = get_unique_filepath(output_video_path_from_config)
    vid_save = cv2.VideoWriter(unique_output_video_path, cv2.VideoWriter_fourcc('M','J','P','G'), fps, (frame_width, frame_height))
    print(f"Saving tracked video to {unique_output_video_path}")

    # Data output
    output_raw_data_path = config['output_raw_data_path']
    output_dir_data = os.path.dirname(output_raw_data_path)
    if not os.path.exists(output_dir_data):
        os.makedirs(output_dir_data)

# Initialize list to store all track data
all_bbox_list = []

# Load the trained YOLOv8 model
model = YOLO("yolov8n.pt")

track_history = defaultdict(lambda: [])

while vid_cap.isOpened():
    success, frame = vid_cap.read()

    if success:
        result = model.track(frame, persist=True)
        annotated_frame = result[0].plot()

        if result[0].boxes.id is not None:
            boxes = result[0].boxes.xywh.cpu()
            track_ids = result[0].boxes.id.int().cpu().tolist()

            for box, track_id in zip(boxes, track_ids):
                x, y, w, h = box
                
                if save_status:
                    raw_bbox_data = (
                        int(vid_cap.get(cv2.CAP_PROP_POS_FRAMES)),
                        track_id,
                        float(x),
                        float(y),
                        float(w),
                        float(h)
                    )
                    all_bbox_list.append(raw_bbox_data)

                if show_status:
                    track = track_history[track_id]
                    track.append((float(x), float(y) + (float(h) * (0.5 - track_height / 100))))
                    points = np.hstack(track).astype(np.int32).reshape((-1, 1, 2))
                    cv2.polylines(annotated_frame, [points], isClosed=False, color=(230, 0, 0), thickness=10)

        if vid_save is not None:
            vid_save.write(annotated_frame)

        if show_status:
            im = cv2.resize(annotated_frame, (960, 540))
            cv2.imshow("frame", im)
        
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
    else:
        break

vid_cap.release()
if vid_save is not None:
    vid_save.release()
if show_status:
    cv2.destroyAllWindows()

# Save all bounding box data to a .mat file
if save_status and all_bbox_list:
    dtype = [('frame', 'int32'), ('track_id', 'int32'), ('x', 'float64'), ('y', 'float64'), ('w', 'float64'), ('h', 'float64')]
    bboxArray = np.array(all_bbox_list, dtype=dtype)

    unique_output_raw_path = get_unique_filepath(output_raw_data_path)
    savemat(unique_output_raw_path, {'bboxDataAll': bboxArray})
    print(f"Saved all tracking data to {unique_output_raw_path}")

#------------- END OF MAIN FUNCTION --------------