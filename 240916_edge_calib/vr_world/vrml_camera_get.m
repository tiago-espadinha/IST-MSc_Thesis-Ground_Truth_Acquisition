%-------------------------------------------------
%
% VRML_CAMERA_GET - Retrieves camera parameters from a VRML world.
% This function gets the current position, orientation (as Euler angles),
% and field of view of the main camera in the VRML world.
%
% Inputs:
%   wnodes : struct : A struct containing the VRML world nodes.
%
% Outputs:
%   cam_params : vector : Camera parameters [tx, ty, tz, r_roll, r_pitch, r_yaw, fov].
%
% Other m-files required: rotm2eul.m, axang2rotm.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function cam_params = vrml_camera_get(wnodes)

    fov = getfield(wnodes.cameraMain, 'fieldOfView');
    position = getfield(wnodes.cameraMain, 'position');
    orientation = getfield(wnodes.cameraMain, 'orientation');
    orientation = rotm2eul(axang2rotm(orientation));
    cam_params = [position orientation fov];
end

%------------- END OF MAIN FUNCTION --------------