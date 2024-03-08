%-------------------------------------------------
%
% DEMO_IMAGE_SUB - Demonstrates the usage of the image_sub function.
% This script sets up the necessary parameters and calls image_sub to perform
% background subtraction on a sample image.
%
% Inputs:
%   None
%
% Outputs:
%   output_image   : file   : The generated mask image saved to output_path.
%   display_figure : figure : A MATLAB figure displaying processing steps.
%
% Other m-files required: image_sub.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% March 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function demo_image_sub()

    disp('Running demo - Image Subtraction');

    % Define file paths
    image_path = 'viena_center_near.jpg';
    background_path = 'viena_background.jpg'; 
    output_path = 'mask_out.jpg';

    % Set threshold
    threshold = 0.1;

    % Run the image subtraction function
    image_sub(image_path, background_path, threshold, output_path);
    fprintf('Demo for image_sub completed.\n');
end

%------------- END OF MAIN FUNCTION --------------