# MPC Simulation

## Description

This folder contains MATLAB and Simulink files for a Model Predictive Control (MPC) simulation designed to control the speed and steering of an autonomous electric vehicle. The project focuses on path tracking, speed profile optimization, and evaluating the vehicle's performance under different conditions.

## Workflow

1.  Open MATLAB.
2.  Ensure `acados` and `CasADi` are properly installed and configured. Run `check_acados_requirements.m` to verify.
3.  Run `main2.m`. This script will:
    a.  Load the vehicle model and parameters.
    b.  Select a predefined path and pitch profile.
    c.  Generate or load an optimized speed profile.
    d.  Set up and run the MPC solver using `acados`.
    e.  Simulate the vehicle dynamics using the `NEWTstRigidVehicleModelMPC.slx` Simulink model.
    f.  Log simulation data to the `res/` directory.
4.  Run `evalScript.m` to analyze and plot the results from the simulation.

## Dependencies

-   MATLAB
-   Simulink
-   ACADOS
-   CasADi

## Contents

-   **`main2.m`**: The main script that orchestrates the entire simulation.
-   **`NEWTstRigidVehicleModelMPC.slx`**: The primary Simulink model for vehicle dynamics.
-   **`car_model.m`**: Defines the vehicle's dynamic model for the ACADOS solver.
-   **`globalDef.m`**: Defines global constants and parameters used throughout the simulation.
-   **`input_scenario_V3.m`**: Loads various predefined reference paths.
-   **`sp_20_06_21.m`**: Generates an optimized speed profile for a given path.
-   **`evalScript.m`**: A script to plot and evaluate the simulation results.
-   **`check_acados_requirements.m`**: Verifies that all dependencies are met.

### `paths/`
-   Contains `.mat` files with different reference paths for the vehicle to follow.

### `sp/`
-   Stores pre-generated speed profiles to save computation time.

### `res/`
-   The default directory for saving simulation logs and results.

## Notes

-   This simulation is a copy of the thesis work of Fábio Portelinha and serves as a foundation for the development of the VIENA project.
-   The simulation relies heavily on the `acados` toolkit for solving the optimal control problem. Make sure it is correctly installed.
