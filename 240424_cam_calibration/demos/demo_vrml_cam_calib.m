%-------------------------------------------------
%
% DEMO_VRML_CAM_CALIB - Demonstrates the usage of the vrml_cam_calib function.
% This script uses predefined 2D image points and 3D VRML world points
% to calculate the camera matrix and related parameters, then visualizes the results.
%
% Inputs:
%   None
%
% Outputs:
%   Displays two figures: one showing the 2D points on the image,
%   and another showing the 3D points and the estimated camera pose.
%
% Other m-files required: vrml_cam_calib.m, hset.m, hrem.m, draw_camera.m, draw_frame.m
% Subfunctions: None
% MAT-files required: cam_calib_input.mat
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% April 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function demo_vrml_cam_calib()

    disp('Running demo - VRML Camera Calibration');

    % Define demo data
    load('cam_calib_input.mat','cam_input')
    i = 3;

    % Run the camera calibration function
    [u, alpha, t, R, error_sum, error, K, P] = vrml_cam_calib(cam_input(i).name, cam_input(i).coords_3d, cam_input(i).coords_2d);

    fprintf('\nDemo for vrml_cam_calib completed.\n');
    fprintf('Rotation Vector (u): [%.4f %.4f %.4f]\n', u(1), u(2), u(3));
    fprintf('Rotation Angle (alpha): %.4f radians\n', alpha);
    fprintf('Translation Vector (t): [%.4f %.4f %.4f]\n', t(1), t(2), t(3));
    fprintf('Total Error Sum: %.4f\n', error_sum);
end

%------------- END OF MAIN FUNCTION --------------