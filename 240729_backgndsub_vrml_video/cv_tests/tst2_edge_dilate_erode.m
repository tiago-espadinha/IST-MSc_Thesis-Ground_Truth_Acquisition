%-------------------------------------------------
%
% TST2_EDGE_DILATE_ERODE - Tests morphological operations for edge refinement.
% This script demonstrates the use of morphological dilation and erosion to
% clean up and connect edges detected by the Canny algorithm after preprocessing.
%
% Inputs:
%   srcImage : string : Path to the source image file (default: 'viena_center_near.jpg').
%
% Outputs:
%   display_figure : figure : A MATLAB figure comparing the original and refined edges.
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

function tst2_edge_dilate_erode(srcImage)

    if nargin < 1; srcImage = 'viena_center_near.jpg'; end

    % Read the image
    image = imread(srcImage);

    % Convert to grayscale
    grayImage = rgb2gray(image);

    % Enhance contrast
    contrastImage = imadjust(grayImage);

    % Denoise the image
    denoisedImage = imgaussfilt(contrastImage, 2);

    % Perform edge detection using Canny method with fine-tuned thresholds
    edges = edge(denoisedImage, 'Canny', [0.1 0.3]);

    % Apply morphological operations to clean up the edges
    se = strel('line', 3, 90);
    edgesDilate = imdilate(edges, se);
    edgesErode = imerode(edgesDilate, se);

    % Display Results
    figure(313), clf;
    subplot(1, 3, 1);
    imshow(image);
    title('Original Image');

    subplot(1, 3, 2);
    imshow(edges);
    title('Original Edges Image');

    subplot(1, 3, 3);
    imshow(edgesErode);
    title('Updated Edges Image');

end

%------------- END OF MAIN FUNCTION --------------