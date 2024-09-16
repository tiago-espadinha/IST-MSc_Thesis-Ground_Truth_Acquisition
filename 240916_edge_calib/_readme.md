# Edge-Based VRML Camera Calibration

## Description

This folder contains MATLAB scripts developed for the Ground Truth acquisition for the VIENA project.
These scripts are for calibrating a vehicle and camera system using edge-matching techniques. By aligning a 3D VRML model of a vehicle with its corresponding real-world image, the scripts determine the precise 6-DOF or 7-DOF pose (position and orientation) of the vehicle for each frame.

## Workflow

1.  Open MATLAB.
2.  Run `setup.m` to add the project paths to MATLAB and create the `assets` directory and copy the necessary assets into it from the project's `share-assets/` directory.
3.  Run `run_calibration.m` to start the calibration process. You can specify the mode: `run_calibration('6dof')` or `run_calibration('7dof')`.
4.  Run `error_analysis.m` to compare the calibration results against ground truth data.

## Dependencies

-   MATLAB
-   MATLAB Image Processing Toolbox
-   MATLAB Computer Vision Toolbox
-   MATLAB Virtual Reality Toolbox

## Contents

-   **`run_calibration.m`**: Main script for running the edge-based calibration (6-DOF or 7-DOF).
-   **`error_analysis.m`**: Script to analyze the error of the calibration results.
-   **`setup.m`**: Configures the project environment by copying assets and adding paths.
-   **`config.m`**: Main configuration file for the calibration process.

### `assets/`
-   Contains all necessary files for the simulation, including images and `.mat` files with calibration data.

### `calibration/`
-   **`edge_calib.m`**: Core function that orchestrates the calibration for a single frame.
-   **`normalize_plane.m`**: Aligns the set of calibrated poses to a common ground plane.
-   **`vrml_tune_camera.m`**: Handles the optimization of the vehicle pose to match the rendered VRML scene with the real image.

### `utils/`
-   **`check_input_data.m`**: Script to interactively check and update initial pose guesses.
-   **`display_camera.m`**: Utility to draw a camera in a 3D plot.
-   **`display_plane.m`**: Utility to draw a best-fit plane from 3D points.
-   **`display_vehicle.m`**: Utility to draw a vehicle model in a 3D plot.
-   **`load_real_images.m`**: Loads and resizes images.
-   **`save_results.m`**: Utility to save results to the `outputs` folder.

### `vr_world/`
-   Contains functions for interacting with the VRML world, such as getting/setting camera poses (`vrml_camera_get`, `vrml_camera_set`) and managing the world (`vrml_world_init`, `vrml_world_end`).

### `outputs/`
-   Directory where output files (figures, `.mat` files) are saved.

## Notes

-   The calibration process uses `fminsearch` for optimization, which can be computationally intensive.
-   The final calibration results and figures are saved in the `outputs` directory.
