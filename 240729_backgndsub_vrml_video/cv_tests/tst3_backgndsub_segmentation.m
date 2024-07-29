%-------------------------------------------------
%
% TST3_BACKGNDSUB_SEGMENTATION - Segments a vehicle using background subtraction and contour detection.
% This script isolates a vehicle from its background by performing image
% subtraction, applying a binary threshold, cleaning the resulting mask with
% morphological operations, and then finding and displaying the contours of the detected object.
%
% Inputs:
%   srcImage      : string : Path to the source image file (default: 'viena_center_near.jpg').
%   srcBackground : string : Path to the background image file (default: 'viena_background.jpg').
%
% Outputs:
%   display_figure : figure : A MATLAB figure showing the segmentation result.
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

function tst3_backgndsub_segmentation(srcImage, srcBackground)

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

    % Display Results
    figure(314), clf;
    subplot(1, 3, 1);
    imshow(image_bg);
    title('Background Image');

    subplot(1, 3, 2);
    imshow(image_with_vehicle);
    title('Image with Vehicle');

    subplot(1, 3, 3);
    imshow(image_with_vehicle);
    hold on;
    [B, L] = bwboundaries(filtered_contours, 'noholes');
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2);
    end
    title('Vehicle Isolation');
    hold off;

end

%------------- END OF MAIN FUNCTION --------------