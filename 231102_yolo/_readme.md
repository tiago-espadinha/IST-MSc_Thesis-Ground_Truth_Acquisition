# VIENA YOLO Tracking

## Description

This folder contains Python scripts developed for the Ground Truth aquisition for the VIENA project.
These scripts are designed to track a vehicle in a video using the YOLO (You Only Look Once) object detection algorithm.

## Workflow

1.  Install the required dependencies listed below.
2.  Run `python setup_assets.py` to create the `assets` directory and move the video files into it.
3.  Edit the `config.json` file to set the desired input and output paths, and other parameters.
4.  Run the scripts from your terminal.

### Detection

```bash
python video_detect.py
```

### Pose Estimation

```bash
python video_pose.py
```

### Tracking

```bash
python video_track.py
```

## Dependencies

-   Python 3.x
-   [YOLOv8 (ultralytics)](https://github.com/ultralytics/ultralytics)
-   OpenCV (`opencv-python`)
-   NumPy (`numpy`)
-   SciPy (`scipy`)

## Contents

-   **`video_detect.py`**: Performs real-time object detection on a video stream using a YOLOv8 model.
-   **`video_pose.py`**: Performs real-time human pose estimation and tracking on a video stream using a YOLOv8-pose model.
-   **`video_track.py`**: Performs real-time object tracking on a video stream using a YOLOv8 model and saves the resulting bounding box data to a `.mat` file.
-   **`utils.py`**: Contains the `VideoProcessor` class that encapsulates the common video processing logic.
-   **`setup_assets.py`**: A script to create the `assets` directory and move the video files into it.
-   **`assets/`**: A directory to store your input video files.
-   **`outputs/`**: A directory to store the processed videos and tracking data.

## Notes

-   The `video_track.py` script will output a `.mat` file containing the tracking data in the `outputs` directory.