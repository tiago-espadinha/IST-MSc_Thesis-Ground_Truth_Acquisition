'''
VIDEO_DETECT - This script performs object detection using YOLOv8 model.

It captures video from a file, applies YOLOv8 model to detect 
objects in each frame, and displays the annotated 
frames with bounding boxes and track IDs.

Inputs: 
    None

Outputs: 
    None

Author: Tiago Simões
Project: VIENA
Instituto Superior Técnico
November 2023; Last revision: 16-July-2025
''' 
#------------- BEGIN MAIN FUNCTION ---------------

import cv2
from ultralytics import YOLO
import json
import os

# Load configuration from config.json
with open('config.json', 'r') as f:
    config = json.load(f)['video_detect']

# Get parameters from config
# Determine the video path
video_name = config['video_path']
if os.path.exists(video_name):
    video_path = video_name
elif os.path.exists(os.path.join('assets', video_name)):
    video_path = os.path.join('assets', video_name)
else:
    print(f"Error: Video file '{video_name}' not found in root or assets directory.")
    exit()
show_video = config['show']

# Load the trained YOLOv8 model
model = YOLO("yolov8n.pt")

# Capture video from a file
cap = cv2.VideoCapture(video_path)

while cap.isOpened():
    success, frame = cap.read()

    if success:
        result = model(frame)
        im = cv2.resize(result[0].plot(), (960, 540))
        cv2.imshow("frame", im)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    else:
        break

cap.release()
cv2.destroyAllWindows()

#------------- END OF MAIN FUNCTION --------------