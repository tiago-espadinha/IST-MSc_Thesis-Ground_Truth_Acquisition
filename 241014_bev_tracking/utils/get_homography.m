%-------------------------------------------------
%
% GET_HOMOGRAPHY - Loads or recomputes the homography matrix.
% This function either loads a pre-saved homography matrix or computes a new
% one based on user-selected points if the `compute_homography` flag is set.
%
% Inputs:
%   config : struct : Configuration structure with file paths and flags.
%
% Outputs:
%   H      : matrix : 3x3 homography matrix.
%
% Other m-files required: clickpts.m, my_homography.m, save_results.m
% Subfunctions: None
% MAT-files required: Homography file specified in config.path_homography (optional).
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function H = get_homography(config)

    if config.compute_homography
        % Get matching points from user clicks
        figure(604);
        imshow(config.path_car);
        title('Select source points on the car image');
        homography.srcPoints = clickpts;

        imshow(config.path_floor);
        title('Select destination points on the VRML floor');
        homography.dstPoints = clickpts;
        
        save_results(config.path_homography, homography);
        fprintf('Homography points saved to %s\n', config.path_homography);
    else
        % Load pre-calculated points
        load(config.path_homography, 'srcPoints', 'dstPoints');
        homography.srcPoints = srcPoints;
        homography.dstPoints = dstPoints;
    end

    % Compute homography
    H = my_homography('calc', homography.srcPoints, homography.dstPoints);
end

%------------- END OF MAIN FUNCTION --------------