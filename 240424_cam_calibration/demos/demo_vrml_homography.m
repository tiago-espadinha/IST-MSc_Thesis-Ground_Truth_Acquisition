%-------------------------------------------------
%
% DEMO_VRML_HOMOGRAPHY - Demonstrates the usage of the vrml_homography function.
% This script uses predefined image paths and keypoint data to calculate
% the homography between a real-world image and a VRML background.
% It then determines the wheel base and center of mass of VIENA in the VRML world
% and visualizes the results.
%
% Inputs:
%   None
%
% Outputs:
%   Displays the homography-transformed image and a plot of the wheel base
%   on the VRML background. Prints the calculated center of mass coordinates.
%
% Other m-files required: vrml_homography.m, my_homography.m
% Subfunctions: None
% MAT-files required: homography_input.mat
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% April 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ?--------------

function demo_vrml_homography()

    disp('Running demo - VRML Homography');

    % Define file paths
    viena_image_path = 'viena_center_near.jpg';
    vrml_background_path = 'floor_texture.jpg';
    plot_save_path = 'vrml_homography_plot.fig';
    img_size = [1920, 1080]; % Width, Height

    % Load keypoint data from files
    load('homography_input.mat', 'homography')
    src_points = homography.src_points;
    dst_points = homography.dst_points;
    wheel_points = homography.wheel_points;

    % Run the homography function
    [x_out, y_out] = vrml_homography(viena_image_path, vrml_background_path, plot_save_path, img_size, src_points, dst_points, wheel_points);

    fprintf('\nDemo for vrml_homography completed.\n');
    fprintf('VIENA Center of Mass in VRML World: X=%.4f m, Y=%.4f m\n', x_out, y_out);
    fprintf('Output saved to %s\n', plot_save_path);
end

%------------- END OF MAIN FUNCTION ?--------------