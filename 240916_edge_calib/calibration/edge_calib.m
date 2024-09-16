%-------------------------------------------------
%
% EDGE_CALIB - Calibrates vehicle and camera pose using edge matching.
% This function initializes the VRML world, loads the real image, and then
% calls the tuning function to perform the optimization-based calibration.
%
% Inputs:
%   config : struct : The configuration structure.
%   state  : struct : The state structure.
%
% Outputs:
%   config : struct : The updated configuration structure.
%   state  : struct : The updated state structure with calibration results.
%
% Other m-files required: vrml_world_init.m, load_real_images.m, vrml_tune_camera.m, vrml_camera_get.m, vrml_world_end.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [config, state] = edge_calib(config, state)
    
    % VRML world initialization
    config = vrml_world_init(config);

    sz = size(config.vrml_backgnd);
    config.real_car = load_real_images(sz, config);
    
    [config, state] = vrml_tune_camera(config, state);
    cam_calib = vrml_camera_get(config.wnodes);
    state.pos_cam = cam_calib(1:3);
    state.rot_cam = cam_calib(4:6);
    if numel(cam_calib) == 7
        state.cam_fov = cam_calib(7);
    end

    % Clean up
    vrml_world_end();
end

%------------- END OF MAIN FUNCTION --------------