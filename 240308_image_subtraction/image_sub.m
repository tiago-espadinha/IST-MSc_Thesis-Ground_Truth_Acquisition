%-------------------------------------------------
%
% IMAGE_SUB - Removes the background of an image and saves the resulting mask.
% This function takes an input image, a background image, and a threshold value.
% It performs background subtraction and saves the generated binary mask to a specified output path.
% It also displays the original image, background image, the intermediate subtraction result,
% and the final mask for visual inspection.
%
% Inputs:
%   image_path      : string : Path to the image to be processed.
%   background_path : string : Path to the background image.
%   threshold       : double : Threshold value for background removal (0-1).
%   output_path     : string : Path to save the output mask image.
%
% Outputs:
%   output_image    : file   : A binary mask image saved to the specified output_path.
%   display_figure  : figure : A MATLAB figure displaying the processing steps.
%
% Other m-files required: subtract_background.m, save_results.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% March 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function image_sub(image_path, background_path, threshold, output_path)
    
    % Perform background subtraction
    mask = subtract_background(image_path, background_path, threshold);

    % Display the results
    figure(101), clf
    
    subplot(2, 2, 1);
    imshow(imread(image_path));
    title('Original Image');

    subplot(2, 2, 2);
    imshow(imread(background_path));
    title('Background Image');

    subplot(2, 2, 3);
    imshow(abs(imsubtract(rgb2gray(imread(background_path)), rgb2gray(imread(image_path)))));
    title('Image Subtraction');

    subplot(2, 2, 4);
    imshow(mask);
    title('Mask');

    % Save the mask image
    save_results(output_path, mask);
end

%------------- END OF MAIN FUNCTION --------------