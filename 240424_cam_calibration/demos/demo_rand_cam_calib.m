%-------------------------------------------------
%
% DEMO_RAND_CAM_CALIB - Demonstrates the usage of the rand_cam_calib function.
% This script generates random 3D points and their 2D projections, then uses
% rand_cam_calib to estimate camera parameters and visualizes the results.
%
% Inputs:
%   None
%
% Outputs:
%   Displays two figures: one showing the 3D points and estimated camera pose,
%   and another showing the 2D projected points.
%
% Other m-files required: rand_cam_calib.m, hset.m, hrem.m, draw_camera.m, draw_frame.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% April 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function demo_rand_cam_calib()

    disp('Running demo - Random Camera Calibration');

    % Number of points for the demo
    n_pts = 30;

    % Run the camera calibration function
    [u, alpha, t, R, error_sum, error, K, P] = rand_cam_calib(n_pts);

    fprintf('\nDemo for rand_cam_calib completed.\n');
    fprintf('Rotation Vector (u): [%.4f %.4f %.4f]\n', u(1), u(2), u(3));
    fprintf('Rotation Angle (alpha): %.4f radians\n', alpha);
    fprintf('Translation Vector (t): [%.4f %.4f %.4f]\n', t(1), t(2), t(3));
    fprintf('Total Error Sum: %.4f\n', error_sum);
end

%------------- END OF MAIN FUNCTION --------------