# VRML Camera Calibration

## Description

This folder contains MATLAB scripts developed for the Ground Truth acquisition for the VIENA project.
These scripts are designed to aid in camera calibration by calculating camera parameters and homography using points from a VRML world.

## Workflow

1.  Open MATLAB.
2.  Run `setup.m` to add the project paths to MATLAB and create the `assets` directory by copying necessary assets from the project's `shared-assets/` directory.
3.  Run the demo scripts in the `demos/` directory to see the functions in action:
    -   `demo_vrml_homography.m` to compute the homography between the VRML world and a real image.
    -   `demo_vrml_cam_calib.m` to calculate the camera matrix using manually selected keypoints.
    -   `demo_rand_cam_calib.m` to validate the calibration algorithm with random points.

## Dependencies

-   MATLAB
-   `clickpts.m` (from Professor José Gaspar's `matlab.my`)
-   `my_homography.m` (from Professor José Gaspar's `matlab.my`)
-   `hrem.m`, `hset.m`, `proj_decomp.m`, `draw_camera.m`, `draw_frame.m` (external utility functions)

## Contents

-   **`vrml_homography.m`**: Generates a homography and calculates VIENA's wheel base and center of mass in the VRML world.
-   **`vrml_cam_calib.m`**: Calculates the camera matrix from matching keypoints between an image and VRML 3D points.
-   **`rand_cam_calib.m`**: Obtains a camera matrix from random 3D points and their 2D projections.
-   **`pixel_to_meters.m`**: Converts pixel coordinates to metric coordinates for the VRML 3D world.
-   **`setup.m`**: Configures the project environment by copying assets and adding paths.

### `assets/`
-   Contains all the necessary files for the simulation to run, such as the images for calibration.

### `demos/`
-   **`demo_vrml_homography.m`**: Demo for `vrml_homography.m`.
-   **`demo_vrml_cam_calib.m`**: Demo for `vrml_cam_calib.m`.
-   **`demo_rand_cam_calib.m`**: Demo for `rand_cam_calib.m`.

### `utils/`
-   **`rotation_matrix.m`**: Computes the rotation matrix from a rotation vector and angle.
-   **`rotation_vector.m`**: Computes the rotation vector and angle from a rotation matrix.
-   **`save_results.m`**: Saves data, figures, or images to the `outputs` directory.

### `outputs/`
-   A directory where the output files are saved.

## Notes

-   Ensure that external utility functions like `hrem.m`, `hset.m`, `proj_decomp.m`, `draw_camera.m`, `draw_frame.m`, and `my_homography.m` are available in your MATLAB path for the scripts to run correctly. These are typically part of Professor José Gaspar's `matlab.my` library.
