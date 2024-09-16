%-------------------------------------------------
%
% VRML_WORLD_END - Closes and clears all VRML worlds.
% This function ensures a clean shutdown by closing all open VRML figures
% and clearing the VRML world objects from memory.
%
% Inputs:
%   None
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
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function vrml_world_end()

    vrclose all;
    vrclear('-force');
    disp('World Deleted');
end

%------------- END OF MAIN FUNCTION --------------