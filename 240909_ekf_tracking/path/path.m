%-------------------------------------------------
%
% PATH - Generates a predefined vehicle path for the simulation.
% This script creates a sequence of states (position and orientation)
% that define a path for the vehicle, plots it, and saves it to a .mat file.
%
% Inputs:
%   None
%
% Outputs:
%   path_viena.mat : file : A .mat file containing the generated path.
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

state = [1.0817 -4.53457 0];
plot(state(1)*10, state(2)*10, 'b+')
hold on
state_array = state;

% left 12m
num = 18;
speed = 3;
for i = 1:num
    state(1) = state(1)+(speed/10);
    state_array(end+1, :) = state;
end

% rotate 15m d
num = 39;
speed = 3;
ang_v = pi/3.9;
for i=1:num
    state(3) = state(3)+(ang_v/10);
    state(3) = mod(state(3), 2*pi);
    state(1) = state(1)+ sin(state(3))*(speed/10);
    state(2) = state(2)- cos(state(3))*(speed/10);
    state_array(end+1, :) = state;
end

% right 24m
num = 36;
speed = -3;
for i = 1:num
    state(1) = state(1)+(speed/10);
    state_array(end+1, :) = state;
end

% rotate 15m d
num = 39;
speed = 3;
ang_v = pi/3.9;
for i=1:num
    state(3) = state(3)+(ang_v/10);
    state(3) = mod(state(3), 2*pi);
    state(1) = state(1)+ sin(state(3))*(speed/10);
    state(2) = state(2)- cos(state(3))*(speed/10);
    state_array(end+1, :) = state;
end

% left 12m
num = 18;
speed = 3;
for i = 1:num
    state(1) = state(1)+(speed/10);
    state_array(end+1, :) = state;
end

% plot and save the path
save('path_viena.mat', 'state_array')
plot(state_array(:,1), state_array(:,2))
axis equal

%------------- END OF MAIN FUNCTION -------------