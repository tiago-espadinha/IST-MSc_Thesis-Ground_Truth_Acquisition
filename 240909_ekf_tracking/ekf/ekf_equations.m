%-------------------------------------------------
%
% EKF_EQUATIONS - Performs the core prediction or update steps of the EKF.
% This function implements the mathematical equations for the Extended Kalman Filter.
% It can perform either the prediction step (estimating the next state) or the
% update step (correcting the estimate with a new measurement).
%
% Inputs:
%   X_inp   : vector : 5x1 input state vector X(k|k) or X(k+1|k).
%   P_inp   : matrix : 5x5 input covariance matrix P(k|k) or P(k+1|k).
%   zk1     : vector : 3x1 measurement at time k+1.
%   deltaT  : double : Time step in seconds.
%   Qk      : matrix : 5x5 process noise covariance matrix.
%   Rk      : matrix : 3x3 measurement noise covariance matrix.
%   UpdFlag : int    : Flag to select mode (2 for prediction, 0 for update).
%
% Outputs:
%   X_out : vector : 5x1 output state vector X(k+1|k) or X(k+1|k+1).
%   P_out : matrix : 5x5 output covariance matrix P(k+1|k) or P(k+1|k+1).
%
% Other m-files required: None
% Subfunctions: disc_motion, jacob_noise_pred, jacob_noise_upd
% MAT-files required: None
%
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [X_out,P_out] = ekf_equations(X_inp, P_inp, zk1, deltaT, Qk, Rk, UpdFlag)

    % Prediction mode
    if UpdFlag == 2
        Xkk = X_inp;
        Pkk = P_inp;
        Xk1k = disc_motion(Xkk, deltaT);
        [Fk, Nk] = jacob_noise_pred(Xkk, deltaT);
        Pk1k = Fk*Pkk*Fk' + Nk*Qk*Nk';
        
        X_out = Xk1k;
        P_out = Pk1k;
    end

    % Update mode
    if UpdFlag == 0
        Xk1k = X_inp;
        Pk1k = P_inp;
        [Hk1, Mk] = jacob_noise_upd;
        yk1 = zk1 - Xk1k(1:3);
        yk1(3) = wrapToPi(yk1(3));
        Sk1 = Hk1*Pk1k*Hk1' + Mk*Rk*Mk';
        Kk1 = Pk1k*Hk1'*inv(Sk1);
        Xk1k1 = Xk1k + Kk1*yk1;
        Pk1k1 = Pk1k - Kk1*Hk1*Pk1k;
        
        X_out = Xk1k1;
        P_out = Pk1k1;     
    end
end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
%
% DISC_MOTION - function that applies the car' discrete motion model
%
% Inputs:
%   Xkk : vector 5x1 : system's state X(k|k)
%   T   : integer    : time step in seconds
%
% Outputs:
%   Xk1k : vector 5x1 : system's state X(k+1|k)
%
%------------- BEGIN FUNCTION ---------------

function Xk1k = disc_motion(Xkk, T)

    theta = Xkk(3);
    v = Xkk(4);
    phi = Xkk(5);

    % Car length
    L = 2.2;
    
    Xk1k = Xkk + [v*T*cos(theta+phi+v*T/(2*L)*sin(phi)); ...
                  v*T*sin(theta+phi+v*T/(2*L)*sin(phi)); ...
                  v*T/L*sin(phi); ...
                  0; ...
                  0];
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
%
% JACOB_NOISE_PRED - function that computes auxiliary matrices for the
% prediction mode
%
% Inputs:
%   Xkk : vector 5x1 : system's state X(k|k)
%   T   : integer    : time step in seconds
%
% Outputs:
%   Fk : matrix 5x5 : Jacobian matrix of f, F(k+1)
%   Nk : matrix 5x5 : system's odometry noise, N(k+1)
%
%------------- BEGIN FUNCTION ---------------

function [Fk, Nk] = jacob_noise_pred(Xkk, T)

    theta = Xkk(3);
    v = Xkk(4);
    phi = Xkk(5);

    % Car length
    L = 2.2;

    % Simplification
    ca = cos(theta+phi+v*T/(2*L)*sin(phi));
    sa = sin(theta+phi+v*T/(2*L)*sin(phi));

    Fk = eye(5);
    Fk(1:2,3) = v*T*[-sa; ca];
    Fk(1,4) = T*ca-v*T^2/(2*L)*sin(phi)*sa;
    Fk(2,4) = T*sa+v*T^2/(2*L)*sin(phi)*ca;
    Fk(1:2,5) = v*T*(1+v*T/(2*L)*cos(phi))*[-sa; ca];
    Fk(3,4) = T/L*sin(phi);
    Fk(3,5) = v*T/L*cos(phi);

    % System's odometry noise
    Nk = eye(5);

end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
%
% JACOB_NOISE_UPD - function that computes auxiliary matrices for the
% update mode
%
% Inputs:
%   None
%
% Outputs:
%   Hk1 : matrix 3x5 : Jacobian matrix of h, H(k+1)
%   Mk  : matrix 3x3 : sensor's measurement noise, M(k+1)
%
%------------- BEGIN FUNCTION ---------------

function [Hk1,Mk] = jacob_noise_upd()

    % Sensor's measurement noise
    Mk = eye(3);

    % Jacobian matrix of h
    Hk1 = [eye(3), zeros(3,2)];

end

%------------- END OF FUNCTION --------------