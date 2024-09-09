%-------------------------------------------------
%
% PLOT_TRAJECTORY_COMPARISON - Plots and compares different vehicle trajectories.
% This function loads the simulation output data and plots the real,
% predicted, measured, and updated vehicle trajectories on a single graph
% for comparison.
%
% Inputs:
%   path_out_file : string : File path to the simulation output data (.mat).
%
% Outputs:
%   display_figure : figure : A MATLAB figure comparing the trajectories.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: The .mat file specified by path_out_file.
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function plot_trajectory_comparison(path_out_file)
    
    load(path_out_file, 'pose_real', 'pose_predict', 'pose_measurement', 'pose_update');

    color = [35, 105, 138; 64, 173, 65; 210, 79, 80; 200, 150, 0 ]/256;

    figure(411); clf
    hold on; grid on; axis equal

    plot(pose_real(1,:), pose_real(2,:), 'Color', color(1,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5)
    plot(pose_predict(1,2:end), pose_predict(2,2:end), 'Color', color(2,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5)
    plot(pose_measurement(1,2:end), pose_measurement(2,2:end), 'Color', color(3,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5)
    plot(pose_update(1,:), pose_update(2,:), 'Color', color(4,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5)
    
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    legend({['Real Position']
            ['Predicted Position']
            ['Measured Position']
            ['Updated Position']
            }, 'Location', 'southwest');
end

%------------- END OF MAIN FUNCTION --------------