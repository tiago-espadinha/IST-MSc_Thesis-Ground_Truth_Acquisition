function vrml_world_end

%VRML_WORLD_END - Closes the virtual worlds and clears all global variables
%
% Syntax: vrml_world_end
%
% Inputs: none
%
% Outputs: none
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior T�cnico
% March 2013; Last revision: 26-Apr-2013

%------------- BEGIN CODE ---------------

global world
global wnodes
global world_fig

close(world{1});
close(world{2});

delete(world{1});
delete(world{2});

world_fig= [];
wnodes= [];
world= [];

disp('World Deleted');

%------------- END OF CODE --------------
