function [XYTnow, dXYTnow]= car_model(T, L, v, phi, XYTprev)

%CAR_MODEL - Computes the next system's state based on the car model
%
% Inputs:
%   T - time period
%   L - distance between axel shafts
%   v - car's velocity
%   phi - orientation of the wheels with respect to theta
%   XYTprev - previous car's position and orientation [x,y,theta]
%
% Outputs:
%   XYTnow - car's new position and orientation
%   dXYTnow - d(XYTnow)/dT
%
% Original author: Nuno Ribeiro
% Altered by: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% August 2013; Last revision: 13-Aug-2013

%------------- BEGIN MAIN FUNCTION ---------------

%theta dot
dXYTnow(3)=v*sin(phi)/L;
%theta
XYTnow(3)=XYTprev(3)+(dXYTnow(3)*T);
%

%x dot
dXYTnow(1)=v*cos( XYTnow(3)+phi+dXYTnow(3)*T/2);%+dP_c(3)*L/2*sin(dP_c(3));
%y dot
dXYTnow(2)=v*sin( XYTnow(3)+phi+dXYTnow(3)*T/2);%+dP_c(3)*L/2*cos(dP_c(3));

%x
XYTnow(1)=XYTprev(1)+(dXYTnow(1)*T);
%y
XYTnow(2)=XYTprev(2)+(dXYTnow(2)*T);

XYTnow=XYTnow';
dXYTnow=dXYTnow';
    
%------------- END OF MAIN FUNCTION --------------