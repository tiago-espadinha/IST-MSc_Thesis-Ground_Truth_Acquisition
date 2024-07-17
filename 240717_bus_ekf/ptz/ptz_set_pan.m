function Camera=ptz_set_pan(Camera,pan)

%PTZ_SET_PAN - Sets pan in the VRML world
%
% Inputs:
%   Camera - structure with the camera data
%   pan - pan angle in rad
%
% Outputs:
%   Camera - structure with the camera data
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN MAIN FUNCTION ---------------

wRc2=ptz_get_proj_matrix(Camera,degtorad(pan),Camera.tilt);

%VRML    
vector=rotmatrix('to_vec_ang',wRc2);
vrml_world_set('camera',Camera.num,vector);

%Update data
Camera.pan=pan;
Camera.R=wRc2;

%------------- END OF MAIN FUNCTION --------------