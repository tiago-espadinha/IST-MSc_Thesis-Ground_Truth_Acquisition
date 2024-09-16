%-------------------------------------------------
%
% VRML_WORLD_SET - Changes the fields of the VRML nodes.
%
% Inputs:
%   wnodes      : struct : VRML world nodes
%   translation : array  : vehicle position [x, y, z]
%   rotation    : array  : vehicle rotation [roll, pitch, yaw]
%
% Outputs: 
%   None
%
% Other m-files required: eul2rotm, rotm2axang
% Subfunctions: None
% MAT-files required: None
%
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 8-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function vrml_world_set(wnodes, translation, rotation)
    
    rotation = rotm2axang(eul2rotm(rotation));
    wnodes.car.translation = translation;
    wnodes.car.rotation = rotation;
end

%------------- END OF MAIN FUNCTION --------------
