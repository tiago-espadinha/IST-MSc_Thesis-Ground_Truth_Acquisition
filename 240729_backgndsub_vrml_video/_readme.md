# VIENA VRML Background Subtraction

## Description

This folder contains MATLAB scripts to estimate the pose (position and orientation) of a vehicle in a single image. It works by matching the image to a 3D VRML model of the vehicle and scene. The process involves camera calibration and background subtraction techniques to align the virtual world with the real image.

## Workflow

1.  Open MATLAB.
2.  Run `setup.m` to add the project paths to MATLAB and create the `assets` directory and copy the necessary assets into it from the project's `share-assets/` directory.
3.  Run the main script `cam_pose_estimation.m` to perform pose estimation.

## Dependencies

-   MATLAB
-   MATLAB Image Processing Toolbox
-   MATLAB Virtual Reality Toolbox

## Contents

-   **`cam_pose_estimation.m`**: Main script that runs camera tuning and vehicle pose estimation.
-   **`config.m`**: Configuration file for the project.
-   **`setup.m`**: Configures the project environment by copying assets and adding paths.

### `assets/`
-   Contains all the necessary files for the simulation to run, such as the VRML worlds and images.

### `cv_tests/`
-   Contains various scripts for testing and exploring different image processing techniques for edge detection and segmentation.

### `tracking/`
-   **`backgndsub.m`**: Estimates the vehicle pose in a virtual world using background subtraction.
-   **`vrml_tune_camera.m`**: Optimizes VRML camera parameters to match a real image.

### `utils/`
-   **`convert_vector.m`**: Converts between different rotation vector formats.
-   **`load_real_images.m`**: Loads and resizes images for the demos.
-   **`save_results.m`**: Saves data, figures, or images to the `outputs` directory.

### `vr_world/`
-   **`vrml_camera_get.m`**: Retrieves current camera parameters from the VRML world.
-   **`vrml_camera_set.m`**: Sets new camera parameters in the VRML world.
-   **`vrml_world_init.m`**: Initializes the VRML world.
-   **`vrml_world_set.m`**: Sets the vehicle's position and orientation in the VRML world.
-   **`vrml_world_end.m`**: Closes the VRML world.

### `outputs/`
-   A directory where the output files are saved.

## Notes

-   The project makes use of `fminsearch` to optimize camera and vehicle pose, which can be computationally expensive.
-   The simulation outputs are saved in the `outputs` directory.