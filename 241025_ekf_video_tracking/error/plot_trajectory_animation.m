%-------------------------------------------------
%
% PLOT_TRAJECTORY_ANIMATION - Animates the vehicle trajectories from the simulation.
% This function loads the simulation output data and the ORB-SLAM3 data, 
% then creates separate animations for the real, predicted, measured, and 
% updated vehicle trajectories.
%
% Inputs:
%   path_out_file : string : File path to the simulation output data (.mat).
%
% Outputs:
%   None
%
% Other m-files required: draw_car.m
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

function plot_trajectory_animation(path_out_file)
    
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

    figure(712); clf; title('Real Vehicle Trajectory'); axis equal; axis tight; hold on; grid on;
    figure(713); clf; title('EKF Prediction Trajectory'); axis equal; axis tight; hold on; grid on;
    figure(714); clf; title('Measurement Trajectory'); axis equal; axis tight; hold on; grid on;
    figure(715); clf; title('EKF Update Trajectory'); axis equal; axis tight; hold on; grid on;

    for i=1:numMatFrames
        figure(712);
        draw_car(pose_real(1:3, i), 0, 1);

        figure(713);
        draw_car(pose_predict(1:3, i), pose_predict(5, i), 1);

        figure(714);
        draw_car(pose_measurement(1:3, i), 0, 1);

        figure(715);
        draw_car(pose_update(1:3, i), pose_update(5, i), 1);
        
        pause(0.1);
    end
end

%------------- END OF MAIN FUNCTION --------------