# EKF Multi-Bus/Multi-Camera Tracking

## Description

This folder contains MATLAB functions developed for the Ground Truth acquisition for the VIENA project. This simulation extends the EKF tracking concept to a multi-vehicle and multi-camera scenario. It uses a multitasking system to dynamically assign multiple PTZ (Pan-Tilt-Zoom) cameras to track several buses within a VRML environment.

## Workflow

1.  Open MATLAB.
2.  Use `addpathx` to add the project paths to MATLAB by running `addpathxinfo.m`.
3.  Run `vrml_msc.m` to perform the main simulation. This will open a VRML world, simulate the movement of multiple buses, and control multiple cameras to track them.

## Dependencies

-   MATLAB
-   MATLAB Virtual Reality Toolbox

## Contents

-   **`vrml_msc.m`**: The main script that runs the multi-sensor, multi-target tracking simulation.
-   **`addpathxinfo.m`**: Adds project directories to the MATLAB path.

### `data/`
-   Contains `.mat` files with predefined paths for each bus and functions for loading this data.

### `ekf/`
-   **`ekf_bus.m`**: Implements the core Extended Kalman Filter logic for tracking a single bus.
-   **`ekf_equations.m`**: Contains the state prediction and update equations for the bus motion model.
-   **`draw_bus.m`**: A utility to visualize the bus in plots.
-   **`plot_ellipse.m`**: Plots the uncertainty ellipses representing the EKF's covariance.

### `multitasking/`
-   **`multitasking.m`**: An algorithm to assign the most appropriate camera to track a bus based on uncertainty.
-   **`followmanager.m`**: An alternative queue-based algorithm for camera task assignment.
-   **`backgndsub.m`**: Performs background subtraction on camera views to detect the bus and provide a measurement for the EKF update.

### `ptz/`
-   A collection of functions to control the virtual PTZ cameras, including setting pan, tilt, and zoom (`ptz_set_pan_tilt_zoom.m`) and calculating the required angles to view a specific point (`ptz_view_xyzr.m`).

### `virtual_world/`
-   **`vrml_world_init.m`**: Initializes the VRML worlds (one for the main view, one for background subtraction).
-   **`vrml_world_set.m`**: Updates the position and orientation of objects (buses, cameras) in the VRML scene.
-   **`vrml_world_end.m`**: Closes the VRML worlds.
-   **`vr_world.wrl`**: The main VRML scene file.

### `wmr/`
-   Contains a simple motion model for a wheeled mobile robot (`car_model.m`) and an interface to control it (`wmr_bus.m`).

## Notes

-   This simulation is a copy of the thesis work of Tiago Castanheira and serves as a foundation for the development of the VIENA project.
