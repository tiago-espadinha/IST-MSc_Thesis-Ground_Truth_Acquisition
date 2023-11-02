'''
VIDEO_TRACK - This script performs object tracking using YOLOv8 model.

It captures video from a file, applies YOLOv8 model to detect 
and track objects in each frame, displays the annotated 
frames with bounding boxes and track IDs and saves the data in a mat file.

Inputs: 
    None

Outputs: 
    Viena_Tracker_Full : mat file : Bounding box data for all detected objects

Author: Tiago Simões
Project: VIENA
Instituto Superior Técnico
November 2023; Last revision: 16-July-2025
''' 
#------------- BEGIN MAIN FUNCTION ---------------

import cv2
from ultralytics import YOLO
from collections import defaultdict
import numpy as np
from scipy.io import savemat
import json
import os

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
elif os.path.exists(os.path.join('assets', video_name)):
    video_path = os.path.join('assets', video_name)
else:
    print(f"Error: Video file '{video_name}' not found in root or assets directory.")
    exit()

output_video_path = os.path.join('outputs', config['output_video_path'])
output_mat_path = os.path.join('outputs', config['output_mat_path'])

# Capture video from a file
vid_cap = cv2.VideoCapture(video_path)

# Create a dictionary to save the bounding box data
mdic = {"frame": [], "track_id": [], "x": [], "y": [], "w": [], "h": []}

# Save tracking to a file
if save_status:
    # Ensure the output directory exists
    output_dir = os.path.dirname(output_video_path)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    vid_save = cv2.VideoWriter(output_video_path, cv2.VideoWriter_fourcc('M','J','P','G'), 30, (1920, 1080))

# Load the trained YOLOv8 model
model = YOLO("yolov8n.pt")

track_history = defaultdict(lambda: [])


while vid_cap.isOpened():
    success, frame = vid_cap.read()

    if success:
        # Use YOLOv8 to track objects in the frame
        result = model.track(frame, persist=True)

        # Draw the bounding boxes and track IDs on the frame
        annotated_frame = result[0].plot()

        # Get the bounding boxes and track IDs for all detected objects
        if result[0].boxes.id is not None:
            boxes = result[0].boxes.xywh.cpu()
            track_ids = result[0].boxes.id.int().cpu().tolist()


            for box, track_id in zip(boxes, track_ids):
                x,y,w,h = box

                # Save the bounding box data and frame number to a dictionary
                if save_status:
                    mdic["frame"].append(vid_cap.get(cv2.CAP_PROP_POS_FRAMES))
                    mdic["track_id"].append(track_id)
                    mdic["x"].append(x)
                    mdic["y"].append(y)
                    mdic["w"].append(w)
                    mdic["h"].append(h)

                track = track_history[track_id]
                track.append((float(x), float(y)+(float(h)*(0.5-track_height/100))))

                points = np.hstack(track).astype(np.int32).reshape((-1, 1, 2))

                cv2.polylines(annotated_frame, [points], isClosed=False, color=(230, 0, 0), thickness=10)   

        #im = annotated_frame
        im = cv2.resize(annotated_frame, (960, 540))

        if save_status:
            vid_save.write(annotated_frame)

        if show_status:
            cv2.imshow("frame", im)
        
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
    else:
        break

vid_cap.release()
if save_status:
    vid_save.release()
cv2.destroyAllWindows()

# Save bounding box data in a mat file
if save_status:
    savemat(output_mat_path, mdic)

#------------- END OF MAIN FUNCTION --------------