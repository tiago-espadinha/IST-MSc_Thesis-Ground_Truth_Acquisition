%-------------------------------------------------
% 
% RUN_CALIBRATION - Main script to run the edge-based calibration process.
% This script manages the calibration of multiple images, either by running a
% new calibration or loading existing data. It then aligns the resulting poses
% to a common ground plane and saves the final output.
% 
% Inputs:
%   mode : string : (optional) '6dof' or '7dof'. Default is '6dof'.
% 
% Outputs:
%   None
% 
% Other m-files required: config.m, edge_calib.m, normalize_plane.m, save_results.m
% Subfunctions: None
% MAT-files required: The calibration input file specified in config.m.
% 
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
% 
%------------- BEGIN MAIN FUNCTION ---------------

function run_calibration(mode)
    startTime = datetime('now');

    %% 1. Configuration and Data Loading
    if nargin < 1
        mode = '6dof'; % Default to 7dof if no mode is specified
    end
    cfg = config(mode);

    fprintf('Loading frame data from %s...\n', cfg.calib_input);
    load(cfg.calib_input, 'edge_input');
    
    %% 2. Run Calibration
    if cfg.run_new_calibration
        fprintf('Running new %s calibration...\n', cfg.mode);
        num_img = numel(edge_input);
        edge_output(num_img) = struct(); % Pre-allocate struct array

        for i = 1:num_img
            fprintf('Processing image %d of %d: %s\n', i, num_img, edge_input(i).name);
            
            % Create copies of state and config for each iteration
            state = struct('edge_input', edge_input(i));
            cfg.path_car = state.edge_input.name;

            % Run the core calibration function
            [~, state] = edge_calib(cfg, state);
            
            % Store results
            edge_output(i).name = cfg.path_car;
            edge_output(i).car_position = state.pos_car;
            edge_output(i).car_rotation = state.rot_car;
            if strcmp(cfg.mode, '7dof')
                edge_output(i).cam_fov = state.cam_fov;
            end
        end
    else
        fprintf('Loading existing calibration data from %s...\n', cfg.calib_out);
        load(cfg.calib_out, 'edge_output');
    end

    %% 3. Perform Extrinsic Alignment
    fprintf('Aligning poses to the XY plane...\n');
    [edge_output_algn.edge_output_algn, edge_input_algn.edge_input_algn] = normalize_plane(edge_output, edge_input, cfg.mode);
  
    %% 4. Save Final Results 
    if cfg.run_new_calibration
        edge_output_algn.edge_output = edge_output;
    end
    save_results(cfg.calib_out, edge_output_algn);
    save_results(cfg.calib_input, edge_input_algn);    

    fprintf('Process complete.\n');

    endTime = datetime('now');
    elapsedTime = endTime - startTime;
    disp(elapsedTime);
end

%------------- END OF MAIN FUNCTION --------------
