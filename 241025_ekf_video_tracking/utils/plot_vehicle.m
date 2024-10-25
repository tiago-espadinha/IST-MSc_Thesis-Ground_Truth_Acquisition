%-------------------------------------------------
% 
% PLOT_VEHICLE - Plots the vehicle's pose and uncertainty ellipse.
% This function visualizes the vehicle's state by drawing the car and,
% optionally, its covariance ellipse on a dedicated subplot based on the pose type.
% 
% Inputs:
%   vehicle_pose : vector : 3x1 or 5x1 state vector of the vehicle.
%   pose_type    : int    : Type of pose (1: prediction, 2: measurement, 3: update).
%   P            : matrix : 5x5 covariance matrix (optional).
% 
% Outputs:
%   None
% 
% Other m-files required: draw_car.m, plot_ellipse.m
% Subfunctions: None
% MAT-files required: None
% 
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 21-September-2025
% 
%------------- BEGIN MAIN FUNCTION ---------------

function plot_vehicle(vehicle_pose, pose_type, P)

    figure(701);
    subplot(2, 2, pose_type)
    
    if nargin == 3
        [~, ~] = plot_ellipse(P(1:2, 1:2), vehicle_pose(1:2, 1), 'r');
    end

    phi = 0;
    if numel(vehicle_pose) >= 5
        phi = vehicle_pose(5);
    end

    draw_car(vehicle_pose(1:3), phi, 1);
    axis equal; axis padded;

    pose_type_name = ["EKF Prediction", "Image Subtraction", "EKF Update"];
    title([pose_type_name(pose_type), ' Trajectory Estimate']);
    fprintf('%s: x= %.1fm; y= %.1fm; theta= %.1fdeg\n', ...
        pose_type_name(pose_type), vehicle_pose(1), vehicle_pose(2), vehicle_pose(3) * 180 / pi);
end

%------------- END OF MAIN FUNCTION --------------
