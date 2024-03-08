%-------------------------------------------------
%
% SUBTRACT_BACKGROUND - Removes the background of an image through image subtraction.
% This function takes an image and a background image, converts them to grayscale,
% performs absolute difference, and applies a threshold to create a binary mask.
%
% Inputs:
%   image      : string         : Path to the image to be processed.
%   background : string         : Path to the background image.
%   threshold  : double         : Threshold value for background removal (0-1).
%
% Outputs:
%   mask       : logical matrix : A binary mask representing the foreground objects.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% March 2024; Last revision: 9-September-2025
%
%------------- BEGIN FUNCTION ---------------

function mask = subtract_background(image, background, threshold)

    % Load images and convert to grayscale
    image_g = rgb2gray(imread(image));
    background_g = rgb2gray(imread(background));

    % Apply image subtraction and create the mask
    imsub = abs(imsubtract(background_g, image_g));
    mask = imsub > threshold * 255;
end

%------------- END OF FUNCTION --------------