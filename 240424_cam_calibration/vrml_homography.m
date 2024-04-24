%-------------------------------------------------
%
% VRML_HOMOGRAPHY - Computes homography and calculates VIENA's position in VRML world.
% This function computes a homography to map points from a real-world image of
% the VIENA vehicle to a VRML background image. It then uses this homography to
% determine the 2D coordinates of VIENA's wheel base and its center of mass on
% the VRML background, converting these to metric 3D coordinates for the VRML world.
%
% Inputs:
%   viena_image_path     : string : Path to the real-world image of VIENA.
%   vrml_background_path : string : Path to the VRML background image.
%   plot_save_path       : string : Path to save the output plot.
%   img_size             : vector : [width, height] of the image for homography.
%   src_points           : matrix : Nx2 matrix of points from the real-world image.
%   dst_points           : matrix : Nx2 matrix of corresponding points from the VRML image.
%   wheel_points         : matrix : 2x2 matrix of wheel base points on the transformed image.
%
% Outputs:
%   x_out                : double : X-coordinate of VIENA's center of mass in the VRML world (m).
%   y_out                : double : Y-coordinate of VIENA's center of mass in the VRML world (m).
%
% Other m-files required: my_homography.m, clickpts.m, save_results.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% April 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [x_out, y_out] = vrml_homography(viena_image_path, vrml_background_path, plot_save_path, img_size, src_points, dst_points, wheel_points)
    
    use_clickpts = false;

    if nargin < 5
        use_clickpts = true;
    end
    if nargin < 4
        img_size = [1920, 1080]; 
    end
    if nargin < 3
        plot_save_path = 'vrml_homography_plot.jpg';
    end

    % Load Viena image
    figure(221);
    imshow(viena_image_path);
    hold on;
    if use_clickpts
        src_points = clickpts;
    else
        plot(src_points(:,1), src_points(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 3);
    end
    title('VIENA Image');
    hold off;
    
    % Load VRML background image
    figure(222);
    imshow(vrml_background_path);
    hold on;
    if use_clickpts
        dst_points = clickpts;
    else
        plot(dst_points(:,1), dst_points(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 3);
    end
    title('VRML Background');
    hold off;
    
    frame = imread(viena_image_path);
    vrml_bg_img = imread(vrml_background_path);

    % Apply homography to original image
    H = my_homography('calc', src_points, dst_points);
    options = struct('crop2box', [0,0; 0,img_size(2); img_size(1),0; img_size(1),img_size(2)]);
    out = my_homography('apply', H, frame, options);
    
    % Display the homography-transformed image
    figure(223);
    imshow(out);
    hold on;
    if use_clickpts
        wheel_points = clickpts;
    else
        plot(wheel_points(:,1), wheel_points(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 3);
    end
    title('Wheel Base on Homography Transformed Image');
    hold off;

    % Convert wheel base pixel coordinates to meter coordinates of VIENA center
    % of mass for VRML 3D environment
    scaling_factor = 27/1080; % Assuming 27 meters corresponds to 1080 pixels in VRML background
    viena_width = 1.508; % Width of VIENA in meters

    % Calculate angle of the wheel base line
    alpha = atan2((wheel_points(1,2)-wheel_points(2,2)), (wheel_points(1,1)-wheel_points(2,1)));
    alpha = alpha + pi/2; % Adjust to be perpendicular to the wheel base

    % VIENA center coordinates in pixels on the VRML background
    center_x_px = (wheel_points(1,1) + wheel_points(2,1)) / 2;
    center_y_px = (wheel_points(1,2) + wheel_points(2,2)) / 2;

    % Convert to VRML 3D coordinates (x, -y convention)
    % These offsets (24.5, 13.5) are specific to the VRML world origin and scale
    x_out = (center_x_px * scaling_factor) - (cos(alpha) * viena_width / 2) - 24.5;
    y_out = -((center_y_px * scaling_factor) - (sin(alpha) * viena_width / 2) - 13.5);

    % Plot wheel base on VRML background and save image
    figure(224);
    imshow(vrml_bg_img);
    hold on;
    title('Wheel Base on VRML Background');
    plot(wheel_points(:,1), wheel_points(:,2), 'r+', 'MarkerSize', 10, 'LineWidth', 3);
    save_results(plot_save_path);
    hold off;

end

%------------- END OF MAIN FUNCTION --------------