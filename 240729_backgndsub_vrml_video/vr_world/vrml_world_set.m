%-------------------------------------------------
%
% VRML_WORLD_SET - Sets the vehicle's pose in the VRML world.
% This function updates the translation (x, y) and rotation (theta) of the
% vehicle model within the VRML scene.
%
% Inputs:
%   wnodes : struct : A struct containing the VRML world nodes.
%   input  : vector : A vector containing the target pose [x, y, theta].
%
% Outputs:
%   None
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% July 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function vrml_world_set(wnodes, input)

    wnodes.car.translation = [input(1:2), 0];
    wnodes.car.rotation = [0, 0, 1, input(3)];
end

%------------- END OF MAIN FUNCTION --------------