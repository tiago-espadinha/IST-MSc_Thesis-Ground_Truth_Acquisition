%-------------------------------------------------
% 
% EKF_TRACK - Main script for the EKF-based vehicle tracking simulation.
% This script initializes the simulation environment, runs the main tracking
% loop, saves the results, and closes the environment.
% 
% Inputs:
%   None
% 
% Outputs:
%   state : file : A .mat file containing the full simulation state.
%   figure: file : A .fig file containing the final trajectory plot.
% 
% Other m-files required: config.m, vrml_world_init.m, state_ini.m,
%   capture_frames.m, backgndsub.m, ekf_car.m, plot_vehicle.m,
%   save_results.m, vrml_world_end.m
% Subfunctions: run_simulation, update_real_position, ekf_prediction,
%   ekf_measurement, ekf_update, ekf_initialization
% MAT-files required: Path file specified in config.m
% 
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
% 
%------------- BEGIN MAIN FUNCTION ---------------

function ekf_track()
    startTime = datetime('now');
    
    % Load configuration
    cfg = config();

    % Initialize
    cfg = vrml_world_init(cfg);    
    state = state_ini(cfg);

    % Run simulation
    state = run_simulation(cfg, state);
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
    
    figure(401); clf; hold on;
    
    % EKF Initialization
    state = update_real_position(config.wnodes, state);
    state = ekf_initialization(config, state);
    
    for Time = 2:state.max_time
        state.time = Time;
        fprintf('\nTime: %ds\n', state.time);
        
        % Update vehicle's real position
        state = update_real_position(config.wnodes, state);
        
        % EKF Prediction
        state = ekf_prediction(config, state);
        
        % Camera movement and image capture
        config = capture_frames(config);
        
        % Estimate vehicle's position
        state = ekf_measurement(config, state);
        
        % EKF Update
        state = ekf_update(config, state);
    end
end

%------------- END OF FUNCTION --------------


%--------------------------------------------
% 
% UPDATE_REAL_POSITION - Updates the vehicle's real position in the VRML world.
% 
% Inputs:
%   wnodes : struct : world nodes structure containing camera and vehicle information
%   state  : struct : state structure containing vehicle's state
% 
% Outputs:
%   state  : struct : updated state structure with the vehicle's real position
% 
%------------- BEGIN FUNCTION ---------------

function state = update_real_position(wnodes, state)
    
    vrml_world_set(wnodes, state.pose_real(1:3, state.time)');
    plot_vehicle(state.pose_real(1:3, state.time), 1);
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
        ekf_car([], [], state.pose_real(1:3, state.time), config);
    plot_vehicle(state.pose_update(:, 1), 1);
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
    plot_vehicle(state.pose_predict(:, state.time), 2, state.P{state.time});
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

    state.pose_measurement(:, state.time) = backgndsub(config, state.pose_predict(1:3, state.time));
    plot_vehicle(state.pose_measurement(:, state.time), 3);
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
        plot_vehicle(state.pose_update(:, state.time), 4);
    end
end

%------------- END OF FUNCTION --------------
