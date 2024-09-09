%-------------------------------------------------
%
% CAPTURE_FRAMES - Captures a frame from the VRML world.
% This function captures the current view from the main camera in the VRML
% world and stores it in the configuration structure.
%
% Inputs:
%   config : struct : Configuration structure with VRML world figure handle.
%
% Outputs:
%   config : struct : Updated configuration structure with the captured image.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------
 
function [config] = capture_frames(config)

    set(config.world_fig, 'Viewpoint', 'cameraMain');
    config.real_car = capture(config.world_fig);
end

%------------- END OF MAIN FUNCTION ---------------