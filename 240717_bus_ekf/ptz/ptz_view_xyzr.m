function [pan,tilt,zoom]=ptz_view_xyzr(Camera,xyz,rd)

%PTZ_VIEW_XYZR - Computes the pan, tilt and zoom angles, given a camera, the
%xyz coordinates and the radius of the sphere centered in xyz
%
% Inputs:
%   Camera - structure with the camera data
%   xyz - vector 1x3 with the x,y and z coordinates
%   rd - radius of the sphere centered in xyz
%
% Outputs:
%   pan - pan angle in deg
%   tilt - tilt angle in deg
%   zoom - zoom angle in deg
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN MAIN FUNCTION ---------------

[pan,tilt]= ptz_center_xyz(Camera,xyz);

M_w= hset(xyz');
M_c= Camera.cTw*M_w;

M_c=hrem(M_c);

zoom= 2*atand(rd/norm(M_c));

%------------- END OF MAIN FUNCTION --------------