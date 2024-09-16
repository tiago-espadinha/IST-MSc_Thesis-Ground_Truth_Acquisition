%-------------------------------------------------
%
% DISPLAY_PLANE - Draws the best-fit plane for a set of 3D points.
% This function calculates the best-fit plane for a cloud of 3D points using
% SVD and visualizes the plane as a patch in a 3D plot.
%
% Inputs:
%   X : matrix : Nx3 matrix of 3D points.
%
% Outputs:
%   normal   : array : Normal vector of the fitted plane.
%   pt_plane : array : A point on the fitted plane (the centroid).
%
% Other m-files required: None
% Subfunctions: z_plane
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [normal, pt_plane] = display_plane(X)

    % Center the points around the centroid
    centroid = mean(X, 1);
    X_centered = X - centroid;

    % Compute the covariance matrix and perform SVD
    cov_matrix = cov(X_centered);
    [~, ~, V] = svd(cov_matrix);
    normal = V(:, 3);
    pt_plane = centroid;

    disp(['Plane Normal: ', num2str(normal')])
    disp(['Point on Plane: ', num2str(pt_plane)])

    % Define plane vertices    
    planePoints = [
        z_plane(min(X(:, 1)), max(X(:, 2)), normal, pt_plane);
        z_plane(min(X(:, 1)), min(X(:, 2)), normal, pt_plane);
        z_plane(max(X(:, 1)), max(X(:, 2)), normal, pt_plane);
        z_plane(max(X(:, 1)), min(X(:, 2)), normal, pt_plane);
    ];

    % Define faces for the plane
    planeFace = [1 2 4 3];

    % Find Rectangle Aspect Ratio
    width = norm(planePoints(1, :) - planePoints(2, :));
    height = norm(planePoints(2, :) - planePoints(4, :));
    ratio = width/height;
    if ratio < 1
        ratio = 1/ratio;
    end
    disp(['Aspect Ratio: ', num2str(width)])
    disp(['Aspect Ratio: ', num2str(height)])
    disp(['Aspect Ratio: ', num2str(ratio)])

    % Plot the plane
    hold on;
    patch('Vertices', planePoints, 'Faces', planeFace, ...
            'FaceColor', 'green', 'FaceAlpha', 0.05, 'EdgeColor', 'black');
    
    % Set plot properties for better visualization
    xlabel('X'); ylabel('Y'); zlabel('Z');
    axis equal; grid on; view(3); hold off;
end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
% 
% Z_PLANE - Calculates the z-coordinate on a plane for a given x and y.
% 
% Inputs:
%   x        : double : x-coordinate
%   y        : double : y-coordinate
%   normal   : array  : normal vector of the plane
%   pt_plane : array  : a point on the plane
% 
% Outputs:
%   pt_out : array : the full 3D point [x, y, z]
% 
%------------- BEGIN FUNCTION ---------------

% Calculate z values for the plane using the plane equation ax + by + cz = d
function pt_out = z_plane(x, y, normal, pt_plane)
    z = (- normal(1) * (x - pt_plane(1)) ...
         - normal(2) * (y - pt_plane(2)) ...
         + dot(normal, pt_plane)) / normal(3);
    pt_out = [x y z];
end

%------------- END OF FUNCTION --------------