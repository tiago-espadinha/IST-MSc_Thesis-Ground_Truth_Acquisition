function myavi_vrml(framearray,name)

%MYAVI_VRML - Creates a .avi file from frames
%
% Inputs:
%   framearray - Array of frames
%   name - name of the video without .avi
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% May 2013; Last revision: 15-May-2013

%------------- BEGIN CODE ---------------

if nargin<2
    name='video';
end

aviname=strcat(name,'.avi');

myavi(0, struct('aviMK',1, 'aviFPS',15, 'aviFname',aviname))

for i=1:length(framearray)
    myavi(1,framearray{i});
end

myavi(2);
