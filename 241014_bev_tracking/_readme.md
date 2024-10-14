# BEV Tracking

## Description

This folder contains MATLAB scripts developed for the Ground Truth acquisition for the VIENA project.
These scripts are designed to calculate the position of a vehicle in a Bird's Eye View (BEV) perspective by using homography.

## Workflow

1.  Open MATLAB.
2.  Run `setup.m` to add the project paths to MATLAB and create the `assets` directory and copy the necessary assets into it from the project's `share-assets/` directory.
3.  Run `vrml_homography.m` to compute the homography, transform the vehicle image to a BEV perspective, and calculate vehicle positions.
4.  Run `error_analysis.m` to perform Procrustes analysis, comparing the calculated positions against ground truth data.

## Dependencies

-   MATLAB
-   MATLAB Computer Vision Toolbox

## Contents

-   **`vrml_homography.m`**: Main script to generate the BEV image and process images to find vehicle positions.
-   **`error_analysis.m`**: Compares results to the real vehicle location using Procrustes analysis and calculates error metrics.
-   **`setup.m`**: Configures the project environment by copying assets and adding paths.
-   **`config.m`**: Configuration file for the project.

### `assets/`
-   Contains all the necessary files for the simulation to run, such as the images for homography and keypoint data.

### `utils/`
-   **`calculate_center.m`**: Calculates the vehicle's center based on wheel coordinates.
-   **`get_homography.m`**: Loads or recomputes the homography matrix.
-   **`process_images.m`**: Processes a series of vehicle images to find and plot vehicle positions.
-   **`save_results.m`**: Saves results to the `outputs` folder.

### `outputs/`
-   The default directory where output files are saved.

## Notes
- This project relies on manual point selection (`clickpts`) for homography calculation if it's recomputed.