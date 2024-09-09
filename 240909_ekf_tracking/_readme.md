# EKF Tracking Simulation

## Description

This folder contains MATLAB scripts developed for the Ground Truth acquisition for the VIENA project.
These scripts are designed to track a car in a VRML world using an Extended Kalman Filter (EKF).

## Workflow

1.  Open MATLAB.
2.  Run `setup.m` to add the project paths to MATLAB and create the `assets` directory and copy the necessary assets into it from the project's `share-assets/` directory.
3.  Run `ekf_track.m` to perform the main simulation.
4.  Run `error_analysis.m` to generate plots and analyze the simulation results.

## Dependencies

-   MATLAB
-   MATLAB Virtual Reality Toolbox

## Contents

-   **`ekf_track.m`**: The main script that runs the EKF simulation for vehicle tracking.
-   **`config.m`**: Configuration file for the simulation, including EKF parameters and file paths.
-   **`setup.m`**: Configures the project environment by copying assets and adding paths.
-   **`error_analysis.m`**: Script to plot and analyze the results from the EKF simulation.

### `assets/`
-   Contains all the necessary files for the simulation to run, such as the VRML worlds, vehicle path, and background images.

### `ekf/`
-   **`ekf_car.m`**: Implements the EKF for vehicle tracking.
-   **`ekf_equations.m`**: Contains the EKF equations and update logic.

### `error/`
-   **`error_metrics.m`**: Calculates and displays error metrics for the simulation.
-   **`plot_trajectory_animation.m`**: Creates an animation of the vehicle's trajectory.
-   **`plot_trajectory_comparison.m`**: Plots the real, predicted, measured, and updated trajectories for comparison.

### `path/`
-   **`path.m`**: Generates and saves the vehicle's path.
-   **`path_test.m`**: Tests the generated path in the VRML world.

### `tracking/`
-   **`backgndsub.m`**: Performs background subtraction to detect the vehicle.
-   **`state_ini.m`**: Initializes the state structure for the simulation.

### `utils/`
-   **`capture_frames.m`**: Captures frames from the VRML world.
-   **`draw_car.m`**: Draws the car in a plot.
-   **`plot_ellipse.m`**: Plots the uncertainty ellipses for the EKF.
-   **`plot_vehicle.m`**: Plots the vehicle's trajectory and state.
-   **`save_results.m`**: Saves the simulation output.
-   **`tb_optparse.m`**: A utility for parsing options.

### `vr_world/`
-   **`vrml_world_init.m`**: Initializes the VRML world.
-   **`vrml_world_set.m`**: Sets the vehicle's position and orientation in the VRML world.
-   **`vrml_world_end.m`**: Closes the VRML world.

### `outputs/`
-   A directory where the output files are saved.

## Notes

-   The simulation outputs are saved in the `outputs` directory.
-   `utils/plot_ellipse.m` and `utils/tb_optparse.m` are external utility functions used for plotting and option parsing, respectively.
