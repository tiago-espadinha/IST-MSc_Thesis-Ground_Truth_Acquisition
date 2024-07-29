%-------------------------------------------------
%
% LOAD_REAL_IMAGES - Loads and resizes real-world images for pose estimation.
% This function loads the background, vehicle, and optional mask images from
% file paths specified in the configuration struct. It then resizes them to
% match the dimensions of the VRML world's output.
%
% Inputs:
%   sz     : vector : Target size of the images [height, width].
%   config : struct : Configuration structure with image paths.
%
% Outputs:
%   real_backgnd : image : The resized background image.
%   real_car     : image : The resized image containing the car.
%   real_mask    : image : The resized mask image (optional, can be empty).
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% July 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [real_backgnd, real_car, real_mask] = load_real_images(sz, config)

    % Video frame loading
    img_bg = imread(config.path_backgnd);
    img_car = imread(config.path_car);

    % Resize images
    W = sz(2);
    H = sz(1);
    real_backgnd = imresize(img_bg, [H, W]);
    real_car = imresize(img_car, [H, W]);

    if exist('config.path_mask', 'var') && ~isempty(config.path_mask)
        real_mask = imresize(imread(config.path_mask) > 0, [H, W]);
        real_mask = real_mask(:, :, 1);
    else
        real_mask = [];
    end
end

%------------- END OF MAIN FUNCTION --------------