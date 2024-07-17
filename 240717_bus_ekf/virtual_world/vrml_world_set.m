function vrml_world_set(world, class, num, input1, input2)

%VRML_WORLD_SET - Changes the fields of the VRML nodes
%
% Inputs:
%   world - if 1 main world, if 2 background world
%   class - camera or bus
%   num - which camera or which bus
%   input1 - first argument to be changed
%   input2 - second argument to be changed
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% March 2013; Last revision: 12-Aug-2013

%------------- BEGIN CODE ---------------
global wnodes

% Finds the vr_world.wrl file's nodes and puts them in variables

switch class
    case 'camera'
        switch num
            case 1 % South Camera
                if input1~=0
                    setfield(wnodes{world}.camera{1},'orientation',input1);
                end
                if nargin==5
                    setfield(wnodes{world}.camera{1},'fieldOfView',input2);
                end
                vrdrawnow
                
            case 2 % North Camera
                if input1~=0
                    setfield(wnodes{world}.camera{2},'orientation',input1);
                end
                if nargin==5
                    setfield(wnodes{world}.camera{2},'fieldOfView',input2);
                end
                vrdrawnow
                
            case 3 % West Camera
                if input1~=0
                    setfield(wnodes{world}.camera{3},'orientation',input1);
                end
                if nargin==5
                    setfield(wnodes{world}.camera{3},'fieldOfView',input2);
                end
                vrdrawnow
                
            case 4 % East Camera
                if input1~=0
                    setfield(wnodes{world}.camera{4},'orientation',input1);
                end
                if nargin==5
                    setfield(wnodes{world}.camera{4},'fieldOfView',input2);
                end
                vrdrawnow
        end
        
    case 'bus'
        switch num
            case 1 % bus1's position and orientation
                setfield(wnodes{world}.bus{1},'translation',[input1(1:2),0]);
                setfield(wnodes{world}.bus{1},'rotation',[0 0 1 input1(3)]); % rads
                vrdrawnow
                
            case 2 % bus2's position and orientation
                setfield(wnodes{world}.bus{2},'translation',[input1(1:2),0]);
                setfield(wnodes{world}.bus{2},'rotation',[0 0 1 input1(3)]); % rads
                vrdrawnow
                
            case 3 % bus3's position and orientation
                setfield(wnodes{world}.bus{3},'translation',[input1(1:2),0]);
                setfield(wnodes{world}.bus{3},'rotation',[0 0 1 input1(3)]); % rads
                vrdrawnow
                
            case 4 % bus4's position and orientation
                setfield(wnodes{world}.bus{4},'translation',[input1(1:2),0]);
                setfield(wnodes{world}.bus{4},'rotation',[0 0 1 input1(3)]); % rads
                vrdrawnow
        end
end


%------------- END OF CODE --------------
