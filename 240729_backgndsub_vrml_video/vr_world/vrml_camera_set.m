%-------------------------------------------------
%
% VRML_CAMERA_SET - Sets camera parameters in the VRML world.
% This function sets the field of view (FOV), position, and orientation
% of the main camera in the VRML world based on an input vector.
%
% Inputs:
%   wnodes : struct : A struct containing the VRML world nodes.
%   x      : vector : A vector of camera parameters [fov, pos_x, pos_y, pos_z, ori_x, ori_y, ori_z].
%
% Outputs:
%   None
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

function vrml_camera_set(wnodes, x)

    fov = x(1);
    pos = x(2:4);
    ori = x(5:7);
    ori = convert_vector('3to4', ori);

    wnodes.cameraMain.fieldOfView = fov;
    wnodes.cameraMain.position = pos;
    wnodes.cameraMain.orientation = ori;
end

%------------- END OF MAIN FUNCTION --------------