%-------------------------------------------------
%
% CONFIG - Configuration for the EKF Video Tracking simulation.
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
% October 2024; Last revision: 21-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function config = config()

    config = struct();

    % File Paths
    config.video_file = 'Viena_120s.mp4';
    config.bbox_file = 'bbox_data.mat';
    config.path_out_file = 'output_path.mat';
    config.path_out_fig = 'output_figure.fig';
    config.vrml_world = 'viena_scene_v3.wrl';

    % EKF Parameters
    config.Q = diag( [10, 10, 5*pi/180, 20, 3.6*pi/180].^2 );
    config.R = diag( [10, 10, 100*pi/180].^2 );
    config.P_initial = diag([1, 1, 1*pi/180, 1, 1*pi/180]).^2;
    config.pose_ini = [25; 427; 0];

    % Simulation Parameters
    config.time_step = 0.2; % 5fps
    config.delta_t = 0.1; % Time step for EKF integration
    config.visualize_optimization = false;
    config.scale_factor = 50; % Scale factor for visualization

end

%------------- END OF MAIN FUNCTION --------------