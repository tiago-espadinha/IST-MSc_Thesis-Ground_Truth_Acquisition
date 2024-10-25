%-------------------------------------------------
% 
% EKF_VIDEO - Main script for EKF-based vehicle tracking from a video.
% This script initializes the simulation environment, including the VRML world
% and video input. It runs the main tracking loop, which performs EKF
% prediction and update steps for each frame. The measurement for the EKF
% is obtained by estimating the vehicle's pose using edge matching.
% Finally, it saves the simulation results.
% 
% Inputs:
%   None
% 
% Outputs:
%   state : file : A .mat file containing the full simulation state.
%   figure: file : A .fig file containing the final trajectory plot.
% 
% Other m-files required: config.m, vrml_world_init.m, state_ini.m,
%   edge_pose.m, ekf_car.m, plot_vehicle.m, save_results.m, vrml_world_end.m
% Subfunctions: run_simulation, ekf_prediction, ekf_measurement, 
%   ekf_update, ekf_initialization
% MAT-files required: Bounding box file specified in config.m (e.g., 'bbox_data.mat').
% 
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 21-September-2025
% 
%------------- BEGIN MAIN FUNCTION ---------------

function ekf_video()
    startTime = datetime('now');
    
    % Load configuration
    cfg = config();

    % Initialize
    cfg = vrml_world_init(cfg);    
    state = state_ini();
    cfg.vidObj = VideoReader(cfg.video_file);

    % Load Bounding Box data
    load(cfg.bbox_file, 'bboxArray')
    cfg.bboxArray = bboxArray;
    cfg.bboxFrame = [bboxArray.frame];

    % Run simulation
    state = run_simulation(cfg, state);
    state.pose_measurement(1:2, :) = state.pose_measurement(1:2, :)/cfg.scale_factor;
    state.pose_predict(1:2, :) = state.pose_predict(1:2, :)/cfg.scale_factor;
    state.pose_update(1:2, :) = state.pose_update(1:2, :)/cfg.scale_factor;
    save_results(cfg.path_out_file, state);
    save_results(cfg.path_out_fig);

    % Clean up
    vrml_world_end();

    endTime = datetime('now');
    elapsedTime = endTime - startTime;
    disp(elapsedTime);
end

%------------- END OF MAIN FUNCTION --------------


%--------------------------------------------
% 
% RUN_SIMULATION - Main simulation loop for the VIENA EKF project.
% 
% Inputs:
%   config : struct : configuration structure containing project settings
%   state  : struct : state structure containing vehicle's state
% 
% Outputs:
%   state  : struct : updated state structure after simulation
% 
%------------- BEGIN FUNCTION ---------------
function state = run_simulation(config, state)

    figure(701); clf; hold on;
    [H, W, ~] = size(config.vrml_backgnd);
    
    while hasFrame(config.vidObj)
        config.vidFrame = readFrame(config.vidObj);
        config.vidFrame = imresize(config.vidFrame, [H, W]);
        fprintf('\nTime: %.1fs\n', state.time * config.time_step);

        % Find bounding box for current frame
        frameNum = round(config.vidObj.CurrentTime * config.vidObj.FrameRate + 1, 0);
        if ~isempty(find(config.bboxFrame == frameNum, 1))
            config.bboxIdx = find(config.bboxFrame == frameNum);
        end

        if state.time == 1
            state = ekf_initialization(config, state);
        else

            % EKF Prediction
            state = ekf_prediction(config, state);

            % Estimate vehicle's position
            state = ekf_measurement(config, state);

            % EKF Update
            state = ekf_update(config, state);
        end

        state.time = state.time + 1;

        if config.vidObj.CurrentTime + config.time_step > config.vidObj.Duration
            break;
        else
            config.vidObj.CurrentTime = config.vidObj.CurrentTime + config.time_step;
        end
    end
end

%------------- END OF FUNCTION --------------


%--------------------------------------------
% 
% EKF_INITIALIZATION - Initializes the EKF with the first measurement.
% 
% Inputs:
%   config : struct : configuration structure containing EKF settings
%   state  : struct : state structure containing vehicle's state
% 
% Outputs:
%   state  : struct : updated state structure with the initialized vehicle's state
% 
%------------- BEGIN FUNCTION ---------------

function state = ekf_initialization(config, state)
    
    config.EKF_mode = 1; % Set to initialization mode
    
    [state.pose_update(:, 1), state.P{1}] = ...
        ekf_car([], [], config.pose_ini, config);
end

%------------- END OF FUNCTION --------------


%--------------------------------------------
% 
% EKF_PREDICTION - Performs the EKF prediction step.
% 
% Inputs:
%   config : struct : configuration structure containing EKF settings
%   state  : struct : state structure containing vehicle's state
% 
% Outputs:
%   state  : struct : updated state structure with the predicted vehicle's state
% 
%------------- BEGIN FUNCTION ---------------

function state = ekf_prediction(config, state)
    
    config.EKF_mode = 2; % Set to prediction mode
    
    [state.pose_predict(:, state.time), state.P{state.time}] = ...
        ekf_car(state.pose_update(:, state.time - 1), state.P{state.time - 1}, [], config);
    plot_vehicle(state.pose_predict(:, state.time), 1, state.P{state.time});
end
    
%------------- END OF FUNCTION --------------


%--------------------------------------------
% 
% EKF_MEASUREMENT - Estimates the vehicle's position using background subtraction.
% 
% Inputs:
%   config : struct : configuration structure containing EKF settings
%   state  : struct : state structure containing vehicle's state
% 
% Outputs:
%   state  : struct : updated state structure with the estimated vehicle's state
% 
%------------- BEGIN FUNCTION ---------------

function state = ekf_measurement(config, state)

    state.pose_measurement(:, state.time) = ...
        edge_pose(config, state.pose_predict(1:3, state.time));
    plot_vehicle(state.pose_measurement(:, state.time), 2);
end

%------------- END OF FUNCTION --------------


%--------------------------------------------
% 
% EKF_UPDATE - Performs the EKF update step.
% 
% Inputs:
%   config : struct : configuration structure containing EKF settings
%   state  : struct : state structure containing vehicle's state
% 
% Outputs:
%   state  : struct : updated state structure with the updated vehicle's state
% 
%------------- BEGIN FUNCTION ---------------

function state = ekf_update(config, state)
    
    if  sum(state.pose_measurement(:, state.time) == inf) ~= 3
        config.EKF_mode = 0; % Set to update mode
        
        [state.pose_update(:, state.time), state.P{state.time }] = ...
            ekf_car(state.pose_predict(:, state.time), state.P{state.time}, state.pose_measurement(:, state.time), config);
        plot_vehicle(state.pose_update(:, state.time), 3);
    end
end

%------------- END OF FUNCTION --------------
