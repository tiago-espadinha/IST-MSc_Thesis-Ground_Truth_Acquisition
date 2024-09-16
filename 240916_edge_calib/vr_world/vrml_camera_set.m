%-------------------------------------------------
%
% VRML_CAMERA_SET - Sets the camera Field of View (FOV) in a VRML world.
%
% Inputs:
%   wnodes : struct : A struct containing the VRML world nodes.
%   fov    : double : The new field of view value.
%
% Outputs:
%   None
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

function vrml_camera_set(wnodes, fov)

    wnodes.cameraMain.fieldOfView = fov;
end

%------------- END OF MAIN FUNCTION --------------