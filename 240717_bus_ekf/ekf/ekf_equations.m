function [X_out,P_out]= ekf_equations(X_inp, P_inp, zk1, deltaT, Qk, Rk, UpdFlag)

%EKF_BUS - Depending on the update flag, enters in prediction or update mode
%
% Inputs:
%   X_inp: system's state: if prediction mode X(k|k), if update mode X(k+1|k)
%   P_inp: covariance matrix: if prediction mode P(k|k), if update mode P(k+1|k)
%   zk1: observation: if prediction mode [], if update mode z(k+1)
%   deltaT: time step in seconds
%   Qk: matriz of bus' system's noise Q(k)
%   Rk: matrix of bus' measurement's noise R(k)
%   UpdFlag: if 0 update mode, if 2 prediction mode
%
% Outputs:
%   X_out: new system's state: if prediction mode X(k+1|k), if update mode 
%   X(k+1|k+1)
%   P: new covariance matrix: if prediction mode P(k+1|k), if update mode
%   P(k+1|k+1)
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior T�cnico
% August 2013; Last revision: 13-Aug-2013

%------------- BEGIN MAIN FUNCTION ---------------

%prediction mode
if UpdFlag == 2
    Xkk= X_inp;
    Pkk= P_inp;
    Xk1k= disc_motion(Xkk, deltaT);
    [Fk, Nk]= jacob_noise_pred(Xkk, deltaT);
    Pk1k= Fk*Pkk*Fk'+Nk*Qk*Nk';
    
    X_out= Xk1k;
    P_out= Pk1k;
end

%update mode
if UpdFlag == 0
    Xk1k= X_inp;
    Pk1k= P_inp;
    [Hk1,Mk]= jacob_noise_upd;
    yk1= zk1 - Xk1k(1:3);
    Sk1= Hk1*Pk1k*Hk1' + Mk*Rk*Mk';
    Kk1= Pk1k*Hk1'*inv(Sk1);
    Xk1k1= Xk1k+Kk1*yk1;
    Pk1k1= Pk1k - Kk1*Hk1*Pk1k;
    
    X_out= Xk1k1;
    P_out= Pk1k1;     
end

%------------- END OF MAIN FUNCTION ---------------

function Xk1k= disc_motion(Xkk, T)

%disc_motion - function that applies the bus' discrete motion model
%
% Inputs:
%   Xkk: system's state X(k|k)
%   T: time step in seconds
%
% Outputs:
%   Xk1k: new system's state X(k+1|k)

%------------- BEGIN FUNCTION ---------------

theta= Xkk(3);
v= Xkk(4);
phi= Xkk(5);

%bus length
L= 80;

Xk1k= Xkk + [v*T*cos(theta+phi+v*T/(2*L)*sin(phi)); ...
             v*T*sin(theta+phi+v*T/(2*L)*sin(phi)); ...
             v*T/L*sin(phi); ...
             0; ...
             0];

%------------- END OF FUNCTION --------------


function [Fk, Nk]= jacob_noise_pred(Xkk, T)

%jacob_noise_pred - function that computes auxiliary matrices for the
%prediction mode
%
% Inputs:
%   Xkk: system's state X(k|k)
%   T: time step in seconds
%
% Outputs:
%   Fk: Jacobian matrix of f, F(k)
%   Nk: system's odometry noise, N(k)

%------------- BEGIN FUNCTION ---------------

theta=Xkk(3);
v=Xkk(4);
phi=Xkk(5);

%bus length
L=80;

%simplification
ca=cos(theta+phi+v*T/(2*L)*sin(phi));
sa=sin(theta+phi+v*T/(2*L)*sin(phi));

Fk= eye(5);
Fk(1:2,3)= v*T*[-sa; ca];
Fk(1,4)= T*ca-v*T^2/(2*L)*sin(phi)*sa;
Fk(2,4)= T*sa+v*T^2/(2*L)*sin(phi)*ca;
Fk(1:2,5)= v*T*(1+v*T/(2*L)*cos(phi))*[-sa; ca];
Fk(3,4)= T/L*sin(phi);
Fk(3,5)= v*T/L*cos(phi);

%system's odometry noise
Nk=eye(5);

%------------- END OF FUNCTION --------------


function [Hk1,Mk]= jacob_noise_upd

%jacob_noise_upd - function that computes auxiliary matrices for the
%update mode
%
% Outputs:
%   Hk1: Jacobian matrix of h, H(k)
%   Mk: sensor's measurement noise, M(k)

%------------- BEGIN FUNCTION ---------------

%sensor's measurement noise
Mk=eye(3);

%Jacobian matrix of h
Hk1=[eye(3), zeros(3,2)];

%------------- END OF FUNCTION --------------