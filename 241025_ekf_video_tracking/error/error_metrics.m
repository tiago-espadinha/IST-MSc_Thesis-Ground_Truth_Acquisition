%-------------------------------------------------
%
% ERROR_METRICS - Calculates and displays error metrics for the EKF video simulation.
% This function loads the simulation output data, compares it against a
% ORB-SLAM3 file, calculates position and orientation errors,
% computes RMSE and maximum errors, and plots the error over time.
%
% Inputs:
%   path_out_file : string : File path to the simulation output data (.mat).
%
% Outputs:
%   display_figure : figure : A MATLAB figure plotting the position and orientation error.
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

function error_metrics(path_out_file)
    
    % Load EKF data
    load(path_out_file, 'pose_update');
    positions = pose_update(1:2, :)';
    orientations = pose_update(3, :)';

    % Load ORB-SLAM3 data
    orbslamData = readtable('orbslam_data.txt', 'Delimiter', ' ', 'ReadVariableNames', false);
    orbslamTimestamps = orbslamData.Var1; 
    orbslamTimestamps = orbslamTimestamps - orbslamTimestamps(1);
    orbslamPositions = orbslamData{:, [2, 4]};
    orbslamPositions = orbslamPositions * 5; % Apply scaling
    aux = orbslamPositions(:,1);
    orbslamPositions(:, 1) = orbslamPositions(:,2);
    orbslamPositions(:, 2) = -aux;
    orbslamOrientations = orbslamData{:, 5:8};

    % Time synchronization
    timeOffset = 26.5;
    tmp = find(orbslamTimestamps > timeOffset);
    orbslamPositions = orbslamPositions(tmp(1):end, :);
    orbslamOrientations = orbslamOrientations(tmp(1):end, :);
    orbslamTimestamps = orbslamTimestamps(tmp(1):end);
    orbslamTimestamps = orbslamTimestamps - timeOffset;

    fps = 5;
    numMatFrames = size(positions, 1);
    matTimestamps = (0:numMatFrames-1)' / fps;

    % Find closest ORB-SLAM3 points for each EKF point
    closestOrbslamPositions = zeros(numMatFrames, 2);
    closestOrbslamOrientations = zeros(numMatFrames, 1);
    for i = 1:numMatFrames
        [~, closestIndex] = min(abs(orbslamTimestamps - matTimestamps(i)));
        closestOrbslamPositions(i, :) = orbslamPositions(closestIndex, :);
        q = orbslamOrientations(closestIndex, :);
        yawAngle = atan2(2 * (q(4) * q(3) + q(1) * q(2)), 1 - 2 * (q(2)^2 + q(3)^2));
        closestOrbslamOrientations(i) = yawAngle;
    end

    % Use Procrustes to align trajectories
    [d, Z] = procrustes(positions, closestOrbslamPositions, 'scaling', false);

    % Calculate errors
    err_x   = Z(:,1) - positions(:,1);
    err_y   = Z(:,2) - positions(:,2);
    err_ang = closestOrbslamOrientations - orientations;

    err_pos = sqrt(err_x.^2 + err_y.^2);
    err_ang = abs(wrapToPi(err_ang));

    % Root mean squared error
    rmse_pos = mean(err_pos);
    rmse_ang = mean(err_ang);

    % Maximum error
    max_err_pos = max(err_pos);
    max_err_ang = max(err_ang);

    err_ang_deg = rad2deg(err_ang);
    rmse_ang_deg = rad2deg(rmse_ang);
    max_err_ang_deg = rad2deg(max_err_ang);

    fprintf('Position RMSE: %.4f m\n', rmse_pos);
    fprintf('Orientation RMSE: %.4f rad (%.2f deg)\n', rmse_ang, rmse_ang_deg);
    fprintf('Position Max Error: %.4f m\n', max_err_pos);
    fprintf('Orientation Max Error: %.4f rad (%.2f deg)\n', max_err_ang, max_err_ang_deg);
    fprintf('Procrustes Disparity: %.4f\n', d);

    figure(711); clf;
    
    yyaxis left
    plot(matTimestamps, err_pos, 'r', 'LineWidth', 1, 'DisplayName', 'Position Error (m)');
    hold on
    yline(rmse_pos, '--r', 'LineWidth', 1, 'DisplayName', 'Position RMSE');
    ylabel('Position Error (m)')
    ax = gca;
    ax.YAxis(1).Color = 'r';

    yyaxis right
    plot(matTimestamps, err_ang_deg, 'b', 'LineWidth', 1, 'DisplayName', 'Orientation Error (deg)');
    hold on
    yline(rmse_ang_deg, '--b', 'LineWidth', 1, 'DisplayName', 'Orientation RMSE');
    ylabel('Orientation Error (degrees)')
    ax.YAxis(2).Color = 'b';
    
    grid on
    xlabel('Time (s)');
    title('EKF Error Metrics vs. ORB-SLAM3 Data');
    legend('show', 'Location', 'best');
    hold off
end

%------------- END OF MAIN FUNCTION --------------