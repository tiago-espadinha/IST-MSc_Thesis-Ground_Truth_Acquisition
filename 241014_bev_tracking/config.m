%-------------------------------------------------
%
% CONFIG - Configuration for the BEV tracking project.
% This function defines and returns a struct containing all necessary file
% paths and flags to control the execution of the scripts.
%
% Inputs:
%   None
%
% Outputs:
%   config : struct : A struct containing configuration parameters.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function config = config()

    config.path_floor = 'floor_texture.jpg';
    config.path_car = 'viena_center_near.jpg';
    config.path_homography = 'homography.mat';
    config.path_bev_coord = 'coords_bev.mat';
    config.path_img_names = 'img_names.mat';

    config.path_real = 'coords_ground_truth.mat'; % Ground truth coordinates
    config.path_edge = 'coords_edge_6dof.mat'; % Edge-based estimation (without FOV)
    config.path_edge_fov = 'coords_edge_7dof.mat'; % Edge-based estimation (with FOV)
    config.path_bev = 'coords_bev.mat'; % Bird's-Eye-View estimation
    config.path_error_results = 'error_results.mat';

    config.compute_homography = false;
    config.compute_wheel_coords = false;
end

%------------- END OF MAIN FUNCTION --------------