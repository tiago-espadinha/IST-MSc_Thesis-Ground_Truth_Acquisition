function Camera=ptz_set_pan_tilt_zoom(Camera,pan,tilt,zoom)

%PTZ_SET_PAN_TILT_ZOOM - Sets pan, tilt and/or zoom in the VRML world
%
% Inputs:
%   Camera - structure with the camera data
%   pan - pan angle in deg
%   tilt - tilt angle in deg
%   zoom - lens' opening angle in deg
%
% Outputs:
%   Camera - structure with the camera data
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN MAIN FUNCTION ---------------

c2Tw=ptz_get_proj_matrix(Camera,pan,tilt);
wTc2= inv(c2Tw);
wRc2= wTc2(1:3,1:3);

%VRML    
vector=rotmatrix('to_vec_ang',wRc2);
vrml_world_set(1,'camera',Camera.num,vector);
vrml_world_set(2,'camera',Camera.num,vector);

%Update data
Camera.pan= pan;
Camera.tilt= tilt;
Camera.R= c2Tw(1:3,1:3);
Camera.t= c2Tw(1:3,4);

if nargin>3
    Camera= ptz_set_zoom(Camera,zoom);
    Camera.zoom= zoom;
end

%------------- END OF MAIN FUNCTION --------------