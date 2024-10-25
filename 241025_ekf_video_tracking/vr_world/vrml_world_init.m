%-------------------------------------------------
%
% VRML_WORLD_INIT - Initializes the VRML world for the simulation.
% This function closes any existing VRML worlds, opens the specified world file,
% gets handles to the camera and vehicle nodes, and captures an initial
% background image by moving the vehicle out of view.
%
% Inputs:
%   config : struct : The configuration structure containing VRML world settings.
%
% Outputs:
%   config : struct : The updated configuration structure with initialized VRML world handles.
%
% Other m-files required: vrml_world_set.m
% Subfunctions: None
% MAT-files required: None
%
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 21-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [config] = vrml_world_init(config)

    % Close any open worlds
    vrclose all;
    vrclear('-force');

    % Open the VRML worlds
    config.world = vrworld(config.vrml_world);
    open(config.world);

    % Get the figure
    config.world_fig = vrfigure(config.world);

    % Get nodes
    config.wnodes.cameraMain = vrnode(config.world, 'cameraMain');
    config.wnodes.car = vrnode(config.world, 'vehicle');

    % Remove vehicle and obtain background image
    vrml_world_set(config.wnodes, [1e6 1e6 0]);
    set(config.world_fig, 'Viewpoint', 'cameraMain');
    vrdrawnow;
    config.vrml_backgnd = capture(config.world_fig);

    fprintf('World Initiated\n');
end

%------------- END OF MAIN FUNCTION --------------
