%-------------------------------------------------
%
% PLOT_TRAJECTORY_ANIMATION - Animates the vehicle trajectories from the simulation.
% This function loads the simulation output data and creates separate animations
% for the real, predicted, measured, and updated vehicle trajectories.
%
% Inputs:
%   path_out_file : string : File path to the simulation output data (.mat).
%
% Outputs:
%   display_figure : figure : MATLAB figures displaying the trajectory animations.
%
% Other m-files required: draw_car.m
% Subfunctions: None
% MAT-files required: The .mat file specified by path_out_file.
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function plot_trajectory_animation(path_out_file)
    
    load(path_out_file, 'pose_real', 'pose_predict', 'pose_measurement', 'pose_update');

    figure(412), clf
    figure(413), clf
    figure(414), clf
    figure(415), clf

    for i=1:length(pose_real)
        figure(412)
        draw_car(pose_real(1:3, i), 0, 1)
        title('Real Vehicle Trajectory')
        axis equal; axis tight

        figure(415)
        draw_car(pose_update(1:3, i), 0, 1)
        title('EKF Update Trajectory Estimate')
        axis equal; axis tight
    end

    for i=2:length(pose_real)
        figure(413)
        draw_car(pose_predict(1:3, i), 0, 1)
        title('EKF Prediction Trajectory Estimate')
        axis equal; axis tight

        figure(414)
        draw_car(pose_measurement(1:3, i), 0, 1)
        title('Image Subtraction Trajectory Estimate')
        axis equal; axis tight
    end
end

%------------- END OF MAIN FUNCTION --------------