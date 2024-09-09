%-------------------------------------------------
%
% ERROR_METRICS - Calculates and displays error metrics for the EKF simulation.
% This function loads the simulation output data, calculates the position and
% orientation errors, computes the RMSE and maximum errors, and plots the
% error over time.
%
% Inputs:
%   path_out_file : string : File path to the simulation output data (.mat).
%
% Outputs:
%   display_figure : figure : A MATLAB figure plotting the position and orientation error.
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

function error_metrics(path_out_file)
    
    load(path_out_file, 'pose_real', 'pose_update');

    % Calculate errors
    err_x   = pose_update(1,:) - pose_real(1,:);
    err_y   = pose_update(2,:) - pose_real(2,:);
    err_ang = pose_update(3,:) - pose_real(3,:);

    err_pos = sqrt(err_x.^2 + err_y.^2);
    err_ang = abs(err_ang);

    % Root mean squared error
    rmse_pos = mean(err_pos);
    rmse_ang = mean(err_ang);

    % Maximum error
    max_err_pos = max(err_pos);
    max_err_ang = max(err_ang);

    fprintf('Position RMSE: %.4f m \n', rmse_pos);
    fprintf('Orientation RMSE: %.4f rads \n', rmse_pos);
    fprintf('Position Max Error: %.4f m \n', max_err_pos);
    fprintf('Orientation Max Error: %.4f rads \n', max_err_ang);

    figure(410); clf
    hold on; grid on
    plot(1:length(pose_real), err_pos, 'r', 'LineWidth', 1);
    plot(1:length(pose_real), err_ang, 'b', 'LineWidth', 1);
    yline(rmse_pos, '--r', 'LineWidth', 1);
    yline(rmse_ang, '--b', 'LineWidth', 1);
    xlabel('time (sec)')
    title('Error Analysis')
    legend({['Postion Error (m)']
            ['Orientation Error (rad)']
            ['Position RMSE (m)']
            ['Orientation RMSE (rad)']})
end

%------------- END OF MAIN FUNCTION --------------
