%-------------------------------------------------
%
% VRML_CAMERA_GET - Retrieves camera parameters from the VRML world.
% This function gets the current field of view (FOV), position, and orientation
% of the main camera in the VRML world.
%
% Inputs:
%   wnodes : struct : A struct containing the VRML world nodes.
%
% Outputs:
%   cam_position : vector : A vector of camera parameters [fov, pos_x, pos_y, pos_z, ori_x, ori_y, ori_z].
%
% Other m-files required: convert_vector.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% July 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function cam_position = vrml_camera_get(wnodes)

    fov = getfield(wnodes.cameraMain, 'fieldOfView');
    pos = getfield(wnodes.cameraMain, 'position');
    ori = getfield(wnodes.cameraMain, 'orientation');
    ori = convert_vector('4to3', ori);

    cam_position = [fov pos ori];

end

%------------- END OF MAIN FUNCTION --------------