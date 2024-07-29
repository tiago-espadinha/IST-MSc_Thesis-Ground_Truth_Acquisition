%-------------------------------------------------
%
% TST4_BACKGNDSUB_SEGMENTATION_MASK - Creates a filled mask for vehicle segmentation.
% This script builds on the previous test by not only detecting the vehicle
% via background subtraction and morphological filtering but also creating a
% solid, filled binary mask of the vehicle's shape using `imfill`.
%
% Inputs:
%   srcImage      : string : Path to the source image file (default: 'viena_center_near.jpg').
%   srcBackground : string : Path to the background image file (default: 'viena_background.jpg').
%
% Outputs:
%   display_figure : figure : A MATLAB figure displaying the final filled mask.
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

function tst4_backgndsub_segmentation_mask(srcImage, srcBackground)

    if nargin < 2; srcBackground = 'viena_background.jpg'; end
    if nargin < 1; srcImage = 'viena_center_near.jpg'; end

    % Read the image
    image_bg = imread(srcBackground);
    image_with_vehicle = imread(srcImage);

    % Convert to Grayscale
    gray_bg = rgb2gray(image_bg);
    gray_with_vehicle = rgb2gray(image_with_vehicle);

    % Subtract Images
    diff = abs(double(gray_with_vehicle) - double(gray_bg));

    % Apply Binary Threshold
    threshold = 30;
    binary_mask = diff > threshold;

    % Morphological Operations
    se = strel('square', 9);
    binary_mask = imopen(binary_mask, se);
    binary_mask = imclose(binary_mask, se);

    % Find Contours
    contours = bwconncomp(binary_mask);

    % Filter Contours by Size
    min_area = 500;
    filtered_contours = false(size(binary_mask));
    for i = 1:contours.NumObjects
        if length(contours.PixelIdxList{i}) > min_area
            filtered_contours(contours.PixelIdxList{i}) = true;
        end
    end

    % Create a Filled Mask
    filled_mask = imfill(filtered_contours, 'holes');

    % Display Results
    figure(315), clf;
    subplot(1, 3, 1);
    imshow(image_bg);
    title('Background Image');

    subplot(1, 3, 2);
    imshow(image_with_vehicle);
    title('Image with Vehicle');

    subplot(1, 3, 3);
    imshow(filled_mask);
    title('Filled Mask of Vehicle');

end

%------------- END OF MAIN FUNCTION --------------