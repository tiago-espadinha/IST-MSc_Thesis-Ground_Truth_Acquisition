%-------------------------------------------------
%
% DISPLAY_CAMERA - Displays a camera's frame and model in a 3D plot.
% This function draws a coordinate frame representing the camera's orientation
% and a pyramid model representing the camera's position and field of view.
%
% Inputs:
%   translation : array : Camera position [x, y, z].
%   rotation    : array : Camera rotation [roll, pitch, yaw] in radians.
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

function display_camera(translation, rotation)
    
    rotation = eul2rotm(rotation);
    rotation = rotation * [1 0 0; 0 -1 0; 0 0 -1];
    draw_frame([rotation translation']);

    % Define a pyramid vertices to represent the camera
    % (aligned along the z-axis)
    baseSize = 1; 
    height = 1;
    halfBase = baseSize / 2;

    baseVertices = [
        -halfBase*1.5, -halfBase, height;   % Bottom-left
         halfBase*1.5, -halfBase, height;   % Bottom-right 
         halfBase*1.5,  halfBase, height;   % Top-right 
        -halfBase*1.5,  halfBase, height;   % Top-left
    ];
    tip = [0, 0, 0];  % The camera's position is at the origin

    pyramidVertices = [baseVertices; tip];

    % Define pyramid faces
    pyramidFacesSides = [
        1 2 5;   % bottom-left + bottom-right
        2 3 5;   % bottom-right + top-right
        3 4 5;   % top-right + top-left
        4 1 5;   % top-left + bottom-left
    ];
    pyramidFacesBase = [1 2 3 4];

    % Apply the rotation and translation to the camera vertices
    transformedVertices = (rotation * pyramidVertices')' + translation;
    
    % Plot the pyramid (camera)
    hold on;
    for i = 1:size(pyramidFacesSides, 1)
        patch('Vertices', transformedVertices, 'Faces', pyramidFacesSides(i, :), ...
            'FaceColor', 'blue', 'FaceAlpha', 0.1, 'EdgeColor', 'black');
    end
    for i = 1:size(pyramidFacesBase, 1)
        patch('Vertices', transformedVertices, 'Faces', pyramidFacesBase(i, :), ...
            'FaceColor', 'blue', 'FaceAlpha', 0.1, 'EdgeColor', 'black');
    end

    % Set plot properties for better visualization
    xlabel('X'); ylabel('Y'); zlabel('Z');
    axis equal; grid on; view(3); hold on
end

%------------- END OF MAIN FUNCTION --------------