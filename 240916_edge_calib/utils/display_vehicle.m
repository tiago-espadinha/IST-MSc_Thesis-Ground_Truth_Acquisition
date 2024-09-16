%-------------------------------------------------
%
% DISPLAY_VEHICLE - Displays a vehicle's frame and model in a 3D plot.
% This function draws a coordinate frame representing the vehicle's orientation
% and a simple box model representing the vehicle's body.
%
% Inputs:
%   translation : array : Vehicle position [x, y, z].
%   rotation    : array : Vehicle rotation [roll, pitch, yaw] in radians.
%
% Outputs:
%   None
%
% Other m-files required: draw_frame.m, eul2rotm.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function display_vehicle(translation, rotation)

    rotation = eul2rotm(rotation);
    draw_frame([rotation translation']);
    
    % Define the vehicle vertices for a rectangular body    
    vehicleVertices = [
        -1.6685, -0.754, -0;  % Bottom back
        -1.6685,  0.754, -0;
        -1.6685, -0.754,  1.42;  % Top back
        -1.6685,  0.754,  1.42;
         0.6, -0.754,  1.42;  % Top windshield
         0.6,  0.754,  1.42;
         1.6685, -0.754,  0;  % Bottom front
         1.6685,  0.754,  0;
         1.6685, -0.754,  0.71;  % Top front
         1.6685,  0.754,  0.71;
    ];

    % Define faces for the vehicle
    vehicleFaces = [
        1 2 8 7;  % Bottom
        3 4 6 5;  % Top
        7 8 10 9; % Front
        1 2 4 3;  % Back
        5 6 10 9; % Windshield
    ];
    vehicleFacesSides = [
        2 4 6 10 8; % Left side
        1 3 5 9 7;  % Right side
    ];

    % Apply the rotation, translation to the vertices
    transformedVertices = (rotation * vehicleVertices')' + translation;
    
    % Plot the vehicle
    hold on;
    for i = 1:size(vehicleFaces, 1)
        patch('Vertices', transformedVertices, 'Faces', vehicleFaces(i, :), ...
            'FaceColor', 'red', 'FaceAlpha', 0.1, 'EdgeColor', 'black');
    end
    for i = 1:size(vehicleFacesSides, 1)
        patch('Vertices', transformedVertices, 'Faces', vehicleFacesSides(i, :), ...
            'FaceColor', 'red', 'FaceAlpha', 0.1, 'EdgeColor', 'black');
    end

    % Set plot properties for better visualization
    xlabel('X'); ylabel('Y'); zlabel('Z');
    axis equal; grid on; view(3); hold on;
end

%------------- END OF MAIN FUNCTION --------------