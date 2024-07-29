%-------------------------------------------------
%
% TST5_BACKGNDSUB_SEGMENTATION_MASK - Creates a unique filled mask for vehicle segmentation.
% This script refines the segmentation process by using more aggressive
% morphological operations and filtering to isolate only the largest connected
% component (assumed to be the vehicle), creating a clean, single-object mask.
%
% Inputs:
%   srcImage      : string : Path to the source image file (default: 'viena_center_near.jpg').
%   srcBackground : string : Path to the background image file (default: 'viena_background.jpg').
%
% Outputs:
%   display_figure : figure : A MATLAB figure displaying the unique filled mask and its centroid.
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

function tst5_backgndsub_segmentation_mask(srcImage, srcBackground)

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
    threshold = 55;
    binary_mask = diff > threshold;

    % Morphological Operations (Opening)
    se = strel('square', 9);
    binary_mask = imopen(binary_mask, se);

    % Morphological Operations (Closing)
    se = strel('disk', 45);
    closed_mask = imclose(binary_mask, se);

    % Find Contours
    contours = bwconncomp(closed_mask);

    % Filter Contours by Size
    % Find the size of each contour
    contour_sizes = cellfun(@length, contours.PixelIdxList);

    % Get the maximum contour size and its index
    [max_contour_size, max_contour_index] = max(contour_sizes);
    filtered_contours = false(size(closed_mask));


    filtered_contours(contours.PixelIdxList{max_contour_index}) = true;

    % Perform a final fill to ensure all holes are filled
    filled_mask = imfill(filtered_contours, 'holes');
    mask = false(size(closed_mask));

    % Determine the centroid of the filled mask
    if any(filled_mask(:))
        stats = regionprops(filled_mask, 'Centroid');
        centroid2D = stats.Centroid; 
    else
        centroid2D = [-1, -1];
    end

    % Display Results
    figure(316), clf;
    subplot(2, 2, 1);
    imshow(image_bg);
    title('Background Image');

    subplot(2, 2, 2);
    imshow(image_with_vehicle);
    title('Image with Vehicle');

    subplot(2, 2, 3);
    imshow(filtered_contours);
    title('Filtered Contours');

    subplot(2, 2, 4);
    imshow(filled_mask);
    hold on
    plot(centroid2D(1),centroid2D(2), 'LineStyle', 'none', 'Marker','+')
    title('Filled Mask of Vehicle');

end

%------------- END OF MAIN FUNCTION --------------