%-------------------------------------------------
%
% SETUP - Configures the project environment for the EKF Video Tracking module.
% This script performs two main tasks:
% 1. Adds the project's directories to the MATLAB path to make its functions
%    and scripts accessible.
% 2. Copies required assets from the main 'shared-assets' directory into the
%    local 'assets' directory for this module, if they are not already present.
%
% Inputs:
%   None
%
% Outputs:
%   None
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 21-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function setup()

    disp('Setting up project: EKF Video Tracking...');

    %% Add project paths
    try
        % Get the directory of the current script
        current_dir = fileparts(mfilename('fullpath'));
        addpath(genpath(current_dir));
        disp('Project paths added successfully.');
    catch ME
        warning(ME.identifier, 'Could not add project paths. Make sure "addpathx.m" is in your MATLAB path. Error: %s', ME.message);
    end

    %% Setup assets
    disp('Setting up assets...');

    % List of asset files to copy from share-assets
    asset_files = {'Viena_120s.mp4', 'viena_scene_v3.wrl', 'viena_capture_v2.wrl', ...
                   'viena_texture.jpg', 'orbslam_data.txt', 'bbox_data.mat'};

    % Get the root directory of the overall project
    project_root = fileparts(current_dir);
    share_assets_dir = fullfile(project_root, 'shared-assets');

    % Define the local assets directory for this project
    current_project_assets_dir = fullfile(current_dir, 'assets');
    if ~exist(current_project_assets_dir, 'dir')
        mkdir(current_project_assets_dir);
    end

    % Copy the asset files, if they don't already exist
    for i = 1:length(asset_files)
        src_path = fullfile(share_assets_dir, asset_files{i});
        dest_path = fullfile(current_project_assets_dir, asset_files{i});
        if exist(src_path, 'file')
            if ~exist(dest_path, 'file')
                copyfile(src_path, dest_path);
                fprintf('Copied %s to %s\n', asset_files{i}, current_project_assets_dir);
            else
                fprintf('Asset %s already exists. Skipping.\n', asset_files{i});
            end
        else
            fprintf('Warning: Source asset %s not found in %s\n', asset_files{i}, share_assets_dir);
        end
    end

    [~, current_folder_name, ~] = fileparts(current_dir);
    fprintf('Assets setup complete for %s!\n', current_folder_name);
end

%------------- END OF MAIN FUNCTION --------------