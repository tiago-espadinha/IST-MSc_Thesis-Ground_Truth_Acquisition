%-------------------------------------------------
%
% CAM_POSE_ESTIMATION - Main script to estimate vehicle pose from an image.
% This script loads background and vehicle images, initializes a VRML world,
% tunes the virtual camera to match the real image, and then estimates the
% vehicle's pose (position and orientation) using a background subtraction method.
%
% Inputs:
%   None
%
% Outputs:
%   state : file : A .mat file containing the initial and final pose estimates.
%
% Other m-files required: config.m, vrml_world_init.m, load_real_images.m,
%   vrml_world_set.m, vrml_tune_camera.m, backgndsub.m, save_results.m, vrml_world_end.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% July 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function cam_pose_estimation()
    startTime = datetime('now');
    
    % Load configuration
    cfg = config();

    % VRML world initialization
    cfg = vrml_world_init(cfg);

    % Video frame loading
    sz = size(cfg.vrml_backgnd);
    [cfg.real_backgnd, cfg.real_car, cfg.real_mask] = load_real_images(sz, cfg);

    % VRML camera tune to match real images
    state.pose_predict = cfg.pose_predict;
    vrml_world_set(cfg.wnodes, state.pose_predict');
    [cfg, state] = vrml_tune_camera(cfg, state);

    % Background subtraction
    state.pose_update = backgndsub(cfg, state.pose_predict);
    vrml_world_set(cfg, state.pose_update');

    fprintf('Initial State Estimate: x= %.2fm; y= %.2fm; theta= %.1fdeg\n', state.pose_predict(1), state.pose_predict(2), rad2deg(state.pose_predict(3)));
    fprintf('Final State Estimate:   x= %.2fm; y= %.2fm; theta= %.1fdeg\n', state.pose_update(1), state.pose_update(2), rad2deg(state.pose_update(3)));

    save_results(cfg.path_out_file, state);

    % Clean up
    vrml_world_end();

    endTime = datetime('now');
    elapsedTime = endTime - startTime;
    disp(elapsedTime);
end

%------------- END OF MAIN FUNCTION --------------
