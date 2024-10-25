%-------------------------------------------------
%
% PLOT_TRAJECTORY_COMPARISON - Plots and compares different vehicle trajectories.
% This function loads the simulation output data and the ORB-SLAM3 data, 
% then plots the real, predicted, measured, and updated vehicle trajectories 
% on a single graph for comparison.
%
% Inputs:
%   path_out_file : string : File path to the simulation output data (.mat).
%
% Outputs:
%   None
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: The .mat file specified by path_out_file, and the
%   ORB-SLAM3 file from the assets folder.
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 21-September-2025
%
%------------- BEGIN MAIN FUNCTION --------------- 

function plot_trajectory_comparison(path_out_file)
    
    load(path_out_file, 'pose_predict', 'pose_measurement', 'pose_update');

    % Load and process ORB-SLAM3 data
    orbslamData = readtable('orbslam_data.txt', 'Delimiter', ' ', 'ReadVariableNames', false);
    orbslamTimestamps = orbslamData.Var1; 
    orbslamTimestamps = orbslamTimestamps - orbslamTimestamps(1);
    orbslamPositions = orbslamData{:, [2, 4]};
    orbslamPositions = orbslamPositions * 5;
    aux = orbslamPositions(:,1);
    orbslamPositions(:, 1) = orbslamPositions(:,2);
    orbslamPositions(:, 2) = -aux;
    orbslamOrientations = orbslamData{:, 5:8};

    timeOffset = 26.5;
    tmp = find(orbslamTimestamps > timeOffset);
    orbslamPositions = orbslamPositions(tmp(1):end, :);
    orbslamOrientations = orbslamOrientations(tmp(1):end, :);
    orbslamTimestamps = orbslamTimestamps(tmp(1):end);
    orbslamTimestamps = orbslamTimestamps - timeOffset;

    fps = 5;
    numMatFrames = size(pose_update, 2);
    matTimestamps = (0:numMatFrames-1)' / fps;

    pose_real = zeros(3, numMatFrames);
    for i = 1:numMatFrames
        [~, closestIndex] = min(abs(orbslamTimestamps - matTimestamps(i)));
        pose_real(1:2, i) = orbslamPositions(closestIndex, :);
        q = orbslamOrientations(closestIndex, :);
        pose_real(3, i) = atan2(2 * (q(4) * q(3) + q(1) * q(2)), 1 - 2 * (q(2)^2 + q(3)^2));
    end

    % Align EKF start with real start for visualization
    translation_offset = pose_real(1:2, 1) - pose_update(1:2, 1);
    pose_predict(1:2, :) = pose_predict(1:2, :) + translation_offset;
    pose_measurement(1:2, :) = pose_measurement(1:2, :) + translation_offset;
    pose_update(1:2, :) = pose_update(1:2, :) + translation_offset;

    color = [35, 105, 138; 64, 173, 65; 210, 79, 80; 200, 150, 0 ]/256;

    figure(716); clf;
    hold on; grid on; axis equal;

    plot(pose_real(1,:), pose_real(2,:), 'Color', color(1,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5);
    plot(pose_predict(1,2:end), pose_predict(2,2:end), 'Color', color(2,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5);
    plot(pose_measurement(1,2:end), pose_measurement(2,2:end), 'Color', color(3,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5);
    plot(pose_update(1,:), pose_update(2,:), 'Color', color(4,:), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'o' ,'MarkerSize', 5);
    
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    title('Trajectory Comparison');
    legend({'ORB-SLAM3', 'EKF Prediction', 'EKF Measurement', 'EKF Update'}, 'Location', 'southwest');
end

%------------- END OF MAIN FUNCTION --------------