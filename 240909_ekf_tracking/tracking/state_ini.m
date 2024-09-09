%-------------------------------------------------
%
% STATE_INI - Initializes the state structure for the EKF simulation.
% This function loads the real vehicle path and initializes all state
% vectors and matrices (measurement, prediction, update, covariance)
% required for the simulation.
%
% Inputs:
%   config : struct : Configuration structure containing the path file.
%
% Outputs:
%   state  : struct : The initialized state structure.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: The path file specified in config.path_file.
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------
 
function state = state_ini(config)

    state = struct();
    load(config.path_file, 'state_array');
    state.pose_real = state_array';
    state.time = 1;
    state.max_time = length(state.pose_real);
    state.pose_measurement = zeros(3, state.max_time);
    state.pose_predict = zeros(5, state.max_time);
    state.pose_update = zeros(5, state.max_time);
    state.P = cell(state.max_time);
    state.bgsub_error = zeros(1, state.max_time);
end

%------------- END OF MAIN FUNCTION --------------