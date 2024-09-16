%-------------------------------------------------
%
% CONFIG - Configuration for the edge-based calibration.
% This function defines and returns a struct containing all the necessary
% configuration parameters, such as file paths and calibration mode.
%
% Inputs:
%   mode : string : Calibration mode ('6dof' or '7dof').
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
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function config = config(mode)
    if nargin < 1
        mode = '6dof';
    end
    config.mode = mode;

    % File Paths
    config.vrml_world = 'viena_scene_v2.wrl';
    config.calib_input = 'calibration_input.mat';
    
    if strcmp(config.mode, '6dof')
        config.calib_out = 'calibration_output_6dof.mat';
    elseif strcmp(config.mode, '7dof')
        config.calib_out = 'calibration_output_7dof.mat';
    end

    % General Settings
    config.run_new_calibration = true;
    config.visualize_optimization = false;
end

%------------- END OF MAIN FUNCTION --------------