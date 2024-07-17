function [pan,tilt]=ptz_center_xyz(Camera,xyz)

%PTZ_CENTER_XYZ - Computes the pan and tilt angles, given a camera and the
%xyz coordinates
%
% Inputs:
%   Camera - structure with the camera data
%   xyz - vector 1x3 with the x,y and z coordinates
%
% Outputs:
%   Camera - structure with the camera data
%   pan - pan angle in rad
%   tilt - tilt angle in rad
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN MAIN FUNCTION ---------------

% M_w=hset(xyz');
% 
% M_c=Camera.cTw*M_w;
% 
% pan=atand(M_c(1)/-M_c(3));
% tilt=atand(-M_c(2)/sqrt(M_c(1)^2+(-M_c(3))^2));

M_w=hset(xyz');

M_c=Camera.cTw*M_w;

pan=atand(M_c(1)/M_c(3));
tilt=atand(M_c(2)/sqrt(M_c(1)^2+(M_c(3))^2));

%------------- END OF MAIN FUNCTION --------------