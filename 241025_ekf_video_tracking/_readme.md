# EKF Video Tracking Simulation

## Description

This folder contains MATLAB and Python scripts for vehicle tracking in a real-world video using an Extended Kalman Filter (EKF). The project is part of the VIENA project for Ground Truth acquisition.

The workflow uses YOLOv8 for initial object detection and bounding box generation. The EKF then tracks the vehicle's pose (position and orientation) by matching edges from a VRML model of the vehicle to the detected edges in the video frames.

## Workflow

1.  **Setup Python Environment**:
    -   Navigate to the `yolo/` directory.
    -   Install the required Python packages: `pip install ultralytics opencv-python scipy numpy`

2.  **Generate Bounding Box Data**:
    -   Run `python video_track.py` from the `yolo/` directory to process the video and generate the `bbox_data.mat` file in the `assets/` directory.

3.  **Setup MATLAB Environment**:
    -   Open MATLAB.
    -   Run `setup.m` to add the project paths to MATLAB and copy the necessary assets from the project's `shared-assets/` directory.

4.  **Run EKF Simulation**:
    -   Run `ekf_video.m` to start the main tracking simulation.

5.  **Analyze Results**:
    -   The simulation output is saved in the `outputs/` directory.
    -   Run `error_analysis.m` to generate plots and analyze the tracking error against ground truth data.

## Dependencies

-   MATLAB
-   MATLAB Virtual Reality Toolbox
-   Python 3.x
-   OpenCV for Python
-   Ultralytics (YOLOv8)
-   SciPy
-   NumPy

## Contents

-   **`ekf_video.m`**: The main script that runs the EKF simulation for vehicle tracking from a video.
-   **`config.m`**: Configuration file for the simulation, including EKF parameters and file paths.
-   **`setup.m`**: Configures the project environment by copying assets and adding paths.
-   **`error_analysis.m`**: Script to plot and analyze the results from the EKF simulation.

### `assets/`
-   Contains all the necessary files for the simulation, such as the video, VRML world, and generated bounding box data.

### `ekf/`
-   **`ekf_car.m`**: Implements the EKF for vehicle tracking.
-   **`ekf_equations.m`**: Contains the EKF equations and update logic.

### `error/`
-   **`error_metrics.m`**: Calculates and displays error metrics by comparing the EKF output with ORB-SLAM3 data.
-   **`plot_trajectory_animation.m`**: Creates an animation of the vehicle's trajectory.
-   **`plot_trajectory_comparison.m`**: Plots the real, predicted, measured, and updated trajectories for comparison.

### `tracking/`
-   **`edge_pose.m`**: Estimates the vehicle's pose by matching edges between the VRML model and the video frame.
-   **`state_ini.m`**: Initializes the state structure for the simulation.

### `utils/`
-   Contains utility functions for drawing, plotting, saving results, and option parsing.

### `vr_world/`
-   **`vrml_world_init.m`**: Initializes the VRML world.
-   **`vrml_world_set.m`**: Sets the vehicle's position and orientation in the VRML world.
-   **`vrml_world_end.m`**: Closes the VRML world.

### `yolo/`
-   **`video_track.py`**: Python script to run YOLOv8 object tracking on the video and save bounding box data.
-   **`config.json`**: Configuration for the `video_track.py` script.
-   **`filter_bbox.m`**: MATLAB script to filter bounding box data.

### `outputs/`
-   A directory where the output files are saved.

## Notes
- The ground truth for this simulation is provided in the ORB-SLAM3 format (`orbslam_data.txt`).
- The `yolo/` directory contains a self-contained Python environment for object detection.
