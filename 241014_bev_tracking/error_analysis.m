%-------------------------------------------------
%
% ERROR_ANALYSIS - Compares and visualizes the error between real and estimated coordinate data.
% This script loads ground truth data and various estimated coordinate sets,
% aligns them using Procrustes analysis, calculates the RMSE for each, and
% plots the results for a visual comparison.
%
% Inputs:
%   None
%
% Outputs:
%   None
%
% Other m-files required: config.m, save_results.m
% Subfunctions: procrustes_analysis, calc_rmse, plot_results
% MAT-files required: 
%   - 'coords_ground_truth.mat'
%   - 'coords_edge_6dof.mat'
%   - 'coords_edge_7dof.mat'
%   - 'coords_bev.mat'
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function error_analysis()

    % Initialize a config struct to hold all paths and data.
    cfg = config();

    % Load the necessary coordinate data files into the config struct.
    load(cfg.path_real, 'real_arr');
    state.real_coord = real_arr; 
    load(cfg.path_edge, 'pos_arr');
    state.edge_coord = pos_arr(:,1:2); 
    load(cfg.path_edge_fov, 'pos_arr');
    state.edge_fov_coord = pos_arr(:,1:2); 
    load(cfg.path_bev, 'center_arr');
    state.bev_coord = center_arr; 
    
    % Perform Procrustes analysis to align the estimated coordinates with the real coordinates.
    state = procrustes_analysis(state);
    state = calc_rmse(state);
    plot_results(state);
    save_results(cfg.path_error_results, state);
end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
%
% PROCRUSTES_ANALYSIS - Aligns multiple datasets to a reference dataset.
%
% This function uses Procrustes analysis to find the optimal rotation, 
% translation, and scaling to best align each estimated coordinate set 
% (BEV, Edge, Edge-FOV) to the real-world ground truth coordinates.
%
% Inputs:
%   state : struct : Contains the coordinate data to be analyzed.
%
% Outputs:
%   state : struct : Updated struct with disparity values (d_*) and the 
%                    transformed, aligned coordinates.
%
%------------- BEGIN FUNCTION ---------------

function state = procrustes_analysis( state )

    [state.d_bev, state.bev_coord] = procrustes(state.real_coord, state.bev_coord);
    [state.d_edge, state.edge_coord] = procrustes(state.real_coord, state.edge_coord);
    [state.d_edge_fov, state.edge_fov_coord] = procrustes(state.real_coord, state.edge_fov_coord);
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
%
% CALC_RMSE - Calculates the error between aligned and real coordinates.
%
% This function computes the element-wise difference and the overall Root 
% Mean Square Error (RMSE) for each of the aligned datasets against the 
% ground truth data.
%
% Inputs:
%   state : struct : Contains the real and aligned coordinate data.
%
% Outputs:
%   state : struct : Updated struct with error vectors (err_*) and 
%                    RMSE values (rmse_*).
%
%------------- BEGIN FUNCTION ---------------

function state = calc_rmse(state)

    % Calculate element-wise error vectors.
    state.err_bev = state.bev_coord - state.real_coord;
    state.err_edge = state.edge_coord - state.real_coord;
    state.err_edge_fov = state.edge_fov_coord - state.real_coord;

    % Calculate Root Mean Square Error (RMSE) for each dataset.
    state.rmse_bev = sqrt(mean(sum(state.err_bev.^2, 2)));
    state.rmse_edge = sqrt(mean(sum(state.err_edge.^2, 2)));
    state.rmse_edge_fov = sqrt(mean(sum(state.err_edge_fov.^2, 2)));
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
%
% PLOT_RESULTS - Plots the real and aligned coordinate data for comparison.
%
% This function generates a 2D plot showing the ground truth trajectory and
% the three different estimated trajectories after they have been aligned
% by the Procrustes analysis.
%
% Inputs:
%   state : struct : Contains the real and aligned coordinate data.
%
% Outputs:
%   None
%
%------------- BEGIN FUNCTION ---------------

function plot_results(state)

    figure(611); clf; hold on;

    plot_settings = {'Marker', '+', 'MarkerSize', 10, 'LineStyle', 'none', 'LineWidth', 3};
    plot(state.real_coord(:,1), state.real_coord(:,2), plot_settings{:});
    plot(state.bev_coord(:,1), state.bev_coord(:,2), plot_settings{:});
    plot(state.edge_coord(:,1), state.edge_coord(:,2), plot_settings{:});
    plot(state.edge_fov_coord(:,1), state.edge_fov_coord(:,2), plot_settings{:});

    legend({'Real-world', ...
            ['BEV (d = ' num2str(state.d_bev, 3) ')'], ...
            ['Edge (d = ' num2str(state.d_edge, 3) ')'], ...
            ['Edge-Fov (d = ' num2str(state.d_edge_fov, 3) ')']}, ...
            'Location', 'northwest')

    title('Comparison of Real vs. Estimated Coordinates');
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    axis equal; axis tight; axis padded; grid on;
end

%------------- END OF FUNCTION ---------------