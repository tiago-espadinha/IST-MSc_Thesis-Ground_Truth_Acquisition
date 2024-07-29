%-------------------------------------------------
%
% CONFIG - Configuration for the VRML background subtraction and pose estimation.
% This function defines and returns a struct containing all the necessary
% configuration parameters, such as file paths, initial pose estimates,
% and visualization settings.
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
% July 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function config = config()

    config = struct();

    config.vrml_world = 'viena_scene_v1.wrl';
    config.path_backgnd = 'viena_background.jpg';
    config.path_car = 'viena_center_near.jpg';
    config.path_out_file = 'vrml_imsub_demo.mat';
    config.edge_detection = 1;

    config.pose_predict = [1.2817; -4.43457; 0]; % Initial pose estimate [x; y; theta]
    config.visualize_optimization = false;
end

%------------- END OF MAIN FUNCTION --------------