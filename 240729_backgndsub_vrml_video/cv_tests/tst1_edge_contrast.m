%-------------------------------------------------
%
% TST1_EDGE_CONTRAST - Tests contrast enhancement and noise filtering for edge detection.
% This script shows the effect of preprocessing steps, such as contrast
% adjustment (imadjust) and Gaussian filtering, on the result of Canny
% edge detection.
%
% Inputs:
%   srcImage : string : Path to the source image file (default: 'viena_center_near.jpg').
%
% Outputs:
%   display_figure : figure : A MATLAB figure displaying the processing steps and results.
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

function tst1_edge_contrast(srcImage)

    if nargin < 1; srcImage = 'viena_center_near.jpg'; end

    % Read the image
    srcImage = imread(srcImage);

    % Convert to grayscale
    grayImage = rgb2gray(srcImage);
    level = graythresh(grayImage);
    cannythreshold = [level/100 level/2];
    edges1 = edge(grayImage, 'Canny', cannythreshold);


    % Enhance contrast
    contrastImage = imadjust(grayImage);

    % Denoise the image
    denoisedImage = imgaussfilt(contrastImage, 2);

    % Perform edge detection using Canny method
    edges = edge(denoisedImage, 'Canny', cannythreshold);

    % Display Results
    figure(312), clf;
    subplot(2, 3, 1);
    imshow(srcImage);
    title('Original Image');

    subplot(2, 3, 3);
    imshow(edges1);
    title('Original Edges Image');

    subplot(2, 3, 4);
    imshow(contrastImage);
    title('Contrast Image');

    subplot(2, 3, 5);
    imshow(denoisedImage);
    title('Denoised Image');

    subplot(2, 3, 6);
    imshow(edges);
    title('Updated Edges Image');

end

%------------- END OF MAIN FUNCTION --------------