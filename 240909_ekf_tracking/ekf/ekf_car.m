%-------------------------------------------------
%
% EKF_CAR - Main interface for the Extended Kalman Filter operations.
% This function acts as a wrapper to initialize the EKF state or to perform
% a prediction and update cycle, based on the specified EKF mode.
%
% Inputs:
%   X_in            : vector : 5x1 state vector for prediction/update.
%   P_in            : matrix : 5x5 covariance matrix for prediction/update.
%   XYT_measurement : vector : 3x1 measurement vector [x; y; theta] for initialization/update.
%   config          : struct : Configuration struct with EKF_mode and P_initial.
%
% Outputs:
%   car_pose        : vector : 5x1 output state vector.
%   car_covariance  : matrix : 5x5 output covariance matrix.
%
% Other m-files required: ekf_equations.m
% Subfunctions: initEKF, pred_updEKF
% MAT-files required: None
%
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [car_pose, car_covariance] = ekf_car(X_in, P_in, XYT_measurement, config)

    if config.EKF_mode == 1
        [car_pose, car_covariance] = initEKF(XYT_measurement, config);
    else
        [car_pose, car_covariance] = pred_updEKF(X_in, P_in, XYT_measurement, config);
    end
end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
%
% INITEKF - initializes the EKF.
%
% Inputs:
%   XYT            : vector : 3-by-1 x, y and theta coordinates
%   config         : struct : configuration parameters including initial covariance matrix
%
% Outputs:
%   car_pose       : vector : 5-by-1 state car_poseimated by the EKF
%   car_covariance : matrix : 5-by-5 covariance matrix
%
%------------- BEGIN FUNCTION ---------------

function [car_pose, car_covariance] = initEKF(XYT, config)

    car_pose = [XYT; 0; 0];
    car_covariance = config.P_initial;
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
%
% PRED_UPDEKF - Integrates the time step and runs the EKF equations.
%
% Inputs:
%   X_in           : vector : 5-by-1 state car_poseimated by the EKF
%   P_in           : matrix : 5-by-5 covariance matrix
%   zk             : vector : 3-by-1 measurement of the vehicle's position
%   config         : struct : configuration parameters including delta_t, Q, R, and EKF_mode

%
% Outputs:
%   car_pose       : vector : 5-by-1 state car_poseimated by the EKF
%   car_covariance : matrix : 5-by-5 covariance matrix
%
%------------- BEGIN FUNCTION ---------------

function [car_pose, car_covariance] = pred_updEKF(X_in, P_in, zk, config)

    X = X_in;
    P = P_in;
    for i = 1:10
        [X, P] = ekf_equations(X, P, zk, config.delta_t, config.Q, config.R, config.EKF_mode);
    end
    car_pose = X;
    car_covariance = P;
end

%------------- END OF FUNCTION --------------