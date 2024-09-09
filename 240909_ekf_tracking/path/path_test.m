%-------------------------------------------------
%
% PATH_TEST - Tests a predefined vehicle path in the VRML world.
% This function loads a path from a .mat file and animates the vehicle's
% movement along this path in the VRML environment.
%
% Inputs:
%   None
%
% Outputs:
%   None
%
% Other m-files required: config.m, vrml_world_init.m, vrml_world_set.m, vrml_world_end.m
% Subfunctions: None
% MAT-files required: The path file specified in config.m.
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function path_test()

    % Initialize configuration and VRML world
    cfg = config();
    cfg = vrml_world_init(cfg);
    load(cfg.path_file, 'state_array');
    car_path = state_array';
     
    len_path = length(car_path);
    
    % Vehicle movement
    for Time=1:len_path
        xyt_real = [car_path(1,Time); car_path(2,Time); car_path(3,Time)];
        vrml_world_set(cfg.wnodes, xyt_real(:)');
        xyt_act = xyt_real(:);

        fprintf('Time: %ds\n', Time);
        fprintf('Real: x= %.1fm; y= %.1fm; theta= %.1fdeg\n\n', xyt_act(1), xyt_act(2), xyt_act(3)*180/pi);
        vrdrawnow;
    end
    
    vrml_world_end();
end

%------------- END OF MAIN FUNCTION --------------