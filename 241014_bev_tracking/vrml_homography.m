%-------------------------------------------------
%
% VRML_HOMOGRAPHY - Generates homography to map vehicle points to a Bird's Eye View.
% This script computes the homography between the vehicle image and the VRML
% floor plan, applies it to create a BEV image, and then processes a series
% of images to determine the vehicle's position in the BEV space.
%
% Inputs:
%   None
%
% Outputs:
%   None
%
% Other m-files required: config.m, get_homography.m, process_images.m, my_homography.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function vrml_homography()

    cfg = config();    

    % Compute Homography
    H = get_homography(cfg);

    % Apply Homography to create BEV image
    cfg.img_car = imread(cfg.path_car);
    cfg.img_floor = imread(cfg.path_floor);
    [height, width, ~] = size(cfg.img_car);
    options = struct('crop2box', [0, 0; 0, height; width, 0; width, height]);
    cfg.bev_car = my_homography('apply', H, cfg.img_car, options);

    % Process all images to find and plot vehicle positions
    process_images(cfg, H);
end

%------------- END OF MAIN FUNCTION ---------------