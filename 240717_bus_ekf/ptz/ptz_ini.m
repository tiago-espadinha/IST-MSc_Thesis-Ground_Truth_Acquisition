function CamArray=ptz_ini(num)

%PTZ_INI - Initializes an array with num cameras
%
% Inputs:
%   num[1x1] - Number of cameras
%
% Outputs:
%   CamArray{num} - Array of cameras
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN MAIN FUNCTION ---------------

global wnodes

CamArray=struct([]);

if nargin<1
    num=4;
end

for i=1:num
    cTw= get_cTw(i);
    CamArray(i).num= i; % camera identifier
    CamArray(i).pan= 0; % pan angle [deg]
    CamArray(i).tilt= -45; % tilt angle [deg]
    CamArray(i).cTw= cTw;
    CamArray(i).zoom= getfield(wnodes{1}.camera{i},'fieldOfView')*180/pi; % zoom angle [deg]
    CamArray(i).K= zeros(3); % intrinsic parameters matrix
    CamArray(i).R= zeros(3); % rotation matrix
    CamArray(i).t= zeros(3,1); % translation matrix
    CamArray(i).bus= i; %which bus to follow
    CamArray(i).camstring= which_cam(i);
end
    
%------------- END OF MAIN FUNCTION --------------


function cTw=get_cTw(i)

%get_cTw_t - function that, depending on the camera, gets its cTw
%transformation (world to camera coordinates)
%
% Inputs:
%   i - camera number
%
% Outputs:
%   cTw - c_T_w transformation
%   t - translation vector

%------------- BEGIN FUNCTION ---------------

global wnodes

switch i
    case 1
        cRw= [1 0 0; 0 0 1; 0 -1 0];
        position=getfield(wnodes{1}.camera{i},'position');
    case 2
        cRw=[-1 0 0; 0 0 1; 0 1 0];
        position=getfield(wnodes{1}.camera{i},'position');
    case 3
        cRw=[0 -1 0; 0 0 1; -1 0 0];
        position=getfield(wnodes{1}.camera{i},'position');
    case 4
        cRw=[0 1 0; 0 0 1; 1 0 0];
        position=getfield(wnodes{1}.camera{i},'position');
end

t=-position';

bTw=eye(4); % b_T_w
bTw(1:3,4)=t;

cRb=eye(4);
cRb(1:3,1:3)=cRw;
cTw=cRb*bTw;

%------------- END OF FUNCTION --------------

function camstring= which_cam(cam)

switch cam
    case 1
        camstring= 'South Camera';
    case 2
        camstring= 'North Camera';
    case 3
        camstring= 'West Camera';
    case 4
        camstring= 'East Camera';
end