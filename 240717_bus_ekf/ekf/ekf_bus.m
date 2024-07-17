function [est, P]= ekf_bus(bus, XYT, P, follow)

%EKF_BUS - Depending on the follow command, initializes the EKF or enters
%in prediction or update mode
%
% Inputs:
%   bus: number associated with a bus
%   XYT: x, y and theta coordinates
%   P: covariance matrix
%   follow: if 1 initializes EKF, if 0 update mode, if 2 prediction mode
%
% Outputs:
%   est: state estimated by the EKF
%   P: new covariance matrix
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% August 2013; Last revision: 13-Aug-2013

%------------- BEGIN MAIN FUNCTION ---------------

if follow == 1
    %initialize EKF
    [est, P]= initEKF(bus, XYT);
else
    [est, P]= pred_updEKF(bus, XYT, P, follow);
end

%------------- END OF MAIN FUNCTION --------------


function [est, P]=initEKF(bus, XYT)

%initEKF - initializes all global variables necessary for the EKF to
%function properly
%
% Inputs:
%   bus: number associated with a bus
%   XYT: x, y and theta coordinates 
%
% Outputs:
%   est: starting state
%   P: starting covariance matrix

%------------- BEGIN FUNCTION ---------------

global X Q R;

%Starting position
X{bus}= [ XYT; 0; 0];

%EKF system's noise covariance
Q{bus}= diag( [10, 10, 5*pi/180, 20, 7.2*pi/180].^2 );

%EKF measurement's noise covariance
R{bus}= diag( [10, 10, 15*pi/180].^2 );

%Covariance matrix
P= diag([1, 1, 1*pi/180, 1, 1*pi/180]).^2;

%Estimation
est= X{bus};

%------------- END OF FUNCTION --------------


function [est, P]= pred_updEKF(bus, XYT, P, follow)

%pred_updEKF - Function that integrates the time step into ten, running the
%EKF equations ten times for a better estimation.
%
% Inputs:
%   bus: number associated with a bus
%   XYT: x, y and theta coordinates 
%   P: current covariance matrix
%   follow: if 0 update mode, if 2 prediction mode
%
% Outputs:
%   est: state estimated by the EKF
%   P: new covariance matrix

%------------- BEGIN FUNCTION ---------------

global X Q R Time PrevTime

deltaT= Time - PrevTime;
deltaT=deltaT/10;
for i=1:10
    [X{bus}, P]= ekf_equations(X{bus}, P, XYT, deltaT, Q{bus}, R{bus}, follow);
end

est= X{bus};

%------------- END OF FUNCTION --------------