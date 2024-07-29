%-------------------------------------------------
%
% TST0_EDGE_METHODS - Compares various edge detection methods on an input image.
% This script demonstrates and displays the results of several common edge
% detection algorithms: simple (default), Canny, Laplacian of Gaussian (LoG),
% Sobel, and Canny with preprocessing.
%
% Inputs:
%   testNumber : integer : The number of the test to run (default: 0).
%                          0: All tests, 1: Simple, 2: Canny, 3: LoG,
%                          4: Sobel, 5: Canny with preprocessing.
%   srcImage   : string  : Path to the input image file (default: 'viena_center_near.jpg').
%
% Outputs:
%   display_figure : figure : A MATLAB figure displaying the edge detection results.
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

function tst0_edge_methods(testNumber, srcImage)

    if nargin < 2; srcImage = 'viena_center_near.jpg'; end
    if nargin < 1; testNumber = 0; end

    % Read the image
    srcImage = imread(srcImage);

    % Convert to grayscale
    grayImage= rgb2gray(srcImage);

    %% Basic edge detection using default parameters
    simpleEdge = edge(grayImage);

    %% Edge detection using Canny method with Otsu thresholding

    % Set Canny threshold based on Otsu threshold
    level = graythresh(grayImage);
    cannythreshold = [level/100 level/2];
    cannyEdge = edge(grayImage,'Canny',cannythreshold);

    %% Edge detection using Laplacian of Gaussian (LoG)
    logEdge = edge(grayImage,'log');

    %% Edge detection using Sobel operator and gradient magnitude
    sobelEdge = edge(grayImage,'Sobel');

    %% Edge detection using Canny method with preprocessing
    grayImage = imadjust(grayImage);
    grayImage = imgaussfilt(grayImage, 2);

    level = graythresh(grayImage);
    cannythreshold = [level/100 level/2];
    processedEdge = edge(grayImage, 'Canny', cannythreshold);

    %% Display Results
    figure(311), clf;
    switch testNumber
        case 0
            subplot(2, 3, 1);
            imshow(simpleEdge);
            title('Simple Edge Detection');
            
            subplot(2, 3, 2);
            imshow(cannyEdge);
            title('Canny Edge Detection');
            
            subplot(2, 3, 3);
            imshow(logEdge);
            title('Laplacian of Gaussian Edge Detection');
            
            subplot(2, 3, 4);
            imshow(sobelEdge);
            title('Sobel Edge Detection');
            
            subplot(2, 3, 5);
            imshow(processedEdge);
            title('Canny Edge Detection with Preprocessing');
        case 1
            imshow(simpleEdge);
            title('Simple Edge Detection');
        case 2
            imshow(cannyEdge);
            title('Canny Edge Detection');
        case 3
            imshow(logEdge);
            title('Laplacian of Gaussian Edge Detection');
        case 4
            imshow(sobelEdge);
            title('Sobel Edge Detection');
        case 5
            imshow(processedEdge);
            title('Canny Edge Detection with Preprocessing');
    end

end

%------------- END OF MAIN FUNCTION --------------