%-------------------------------------------------
%
% CONFIG - Configuration for the EKF tracking simulation.
% This function defines and returns a struct containing all the necessary
% configuration parameters, such as file paths, EKF noise matrices,
% and simulation settings.
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
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function config = config()

    config = struct();

    % File Paths
    config.path_file = 'path_viena_v1.mat';
    config.path_out_file = 'output_path.mat';
    config.path_out_fig = 'output_figure.fig';
    config.vrml_world = 'viena_scene_v1.wrl';
    config.error_out_file = 'output_path.mat';

    % EKF Parameters
    config.Q = diag([0.5, 0.5, deg2rad(15), .4, deg2rad(7.2)].^2);
    config.R = diag([0.5, 0.5, deg2rad(15)].^2);
    config.P_initial = diag([.02, .02, deg2rad(1), .02, deg2rad(1)]).^2;

    % Simulation Parameters
    config.delta_t = 0.1; % Time step for EKF integration
    config.visualize_optimization = false;

end

%------------- END OF MAIN FUNCTION --------------