function c2Tw=ptz_get_proj_matrix(Camera,pan,tilt)

%PTZ_GET_PROJ_MATRIX - Computes the projection matrix from the pan and tilt
%angles
%
% Inputs:
%   Camera - structure with the camera data
%   pan - pan angle in deg
%   tilt - tilt angle in deg
%
% Outputs:
%   wRc2 - rotation/transformation matrix that transforms world coordinates
%in camera coordinates after pan and tilt
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN MAIN FUNCTION ---------------

% pan=degtorad(pan);
% tilt=degtorad(tilt);
% 
% cRw=Camera.cTw(1:3,1:3);
% 
% ca=cos(pan);
% sa=sin(pan);
% 
% cb=cos(tilt);
% sb=sin(tilt);
% 
% Rt=[1 0 0; 0 cb -sb; 0 sb cb]; %tilt
% Rp=[ca 0 sa; 0 1 0; -sa 0 ca]; %pan
% 
% c2Rw=Rt*Rp*cRw;
% wRc2=inv(c2Rw);

pan=degtorad(pan);
tilt=degtorad(tilt);

cTw=Camera.cTw;

ca=cos(pan);
sa=sin(pan);

cb=cos(tilt);
sb=sin(tilt);

Rt= [1 0 0 0; 0 cb sb 0; 0 -sb cb 0; 0 0 0 1]; %tilt
Rp= [ca 0 -sa 0; 0 1 0 0; sa 0 ca 0; 0 0 0 1]; %pan

c2Tw= Rt*Rp*cTw;

%------------- END OF MAIN FUNCTION --------------