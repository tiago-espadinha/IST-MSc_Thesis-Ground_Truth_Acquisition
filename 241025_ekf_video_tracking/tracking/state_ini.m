%-------------------------------------------------
%
% STATE_INI - Initializes the state structure for the EKF simulation.
% This function creates and initializes the state structure, which holds
% all state vectors and matrices (measurement, prediction, update, covariance)
% required for the simulation.
%
% Inputs:
%   None
%
% Outputs:
%   state  : struct : The initialized state structure.
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
 
function state = state_ini()

    state = struct();
    state.time = 1;
    state.pose_measurement = zeros(3, 1);
    state.pose_predict = zeros(5, 1);
    state.pose_update = zeros(5, 1);
    state.P = cell(1);
    state.bgsub_error = zeros(1, 1);
end

%------------- END OF MAIN FUNCTION --------------