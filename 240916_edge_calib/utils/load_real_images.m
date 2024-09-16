%-------------------------------------------------
%
% LOAD_REAL_IMAGES - Loads and resizes a real image of the car.
%
% Inputs:
%   sz     : vector : Target size of the image [height, width].
%   config : struct : Configuration structure with the image path.
%
% Outputs:
%   real_car : image : The resized car image.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function real_car = load_real_images(sz, config)

    % Video frame loading
    img_car = imread(config.path_car);

    % Resize images
    W = sz(2);
    H = sz(1);
    real_car = imresize(img_car, [H, W]);
end

%------------- END OF MAIN FUNCTION --------------