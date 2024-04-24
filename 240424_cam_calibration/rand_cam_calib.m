%-------------------------------------------------
%
% RAND_CAM_CALIB - Calibrates a camera using random 3D points and their 2D projections.
% This function generates a set of random 3D points and projects them onto a 2D
% image plane using a predefined camera matrix. It then uses these correspondences
% to re-estimate the camera matrix and its parameters (intrinsic, rotation, translation)
% using a Least Squares Estimation (LSE) method. The function serves as a validation
% of the calibration algorithm.
%
% Inputs:
%   n_pts     : double : The number of random points to generate for calibration.
%
% Outputs:
%   u         : vector : rotation vector
%   alpha     : float  : rotation angle
%   t         : vector : translation vector
%   R         : matrix : rotation matrix
%   error_sum : float  : sum of errors between original and calculated camera matrix
%   error     : vector : error matrix
%   K         : matrix : intrinsic matrix
%   P         : matrix : camera matrix
%
% Other m-files required: hset.m, hrem.m, proj_decomp.m, rotation_vector.m, draw_camera.m, draw_frame.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% April 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [u, alpha, t, R, error_sum, error, K, P] = rand_cam_calib(n_pts)
    
    % Camera Calibration with LSE
    if nargin < 1
        n_pts = 30; % Default number of points if not provided
    end

    % 3D Point Coordinates
    pts_3d = rand(3,n_pts);

    % Camera Matrix
    P = [eye(3) [0 0 -10]'];

    % 2D Point Coordinates with pin-hole camera
    pts_2d = hrem(P*hset(pts_3d));

    % Camera Calibration with LSE
    A = zeros(2*n_pts, 12);

    % LSE System for each pair of points
    for i=1:n_pts
        A(2*i-1,:) = [hset(pts_3d(:,i))' zeros(1,4) -pts_2d(1, i)*hset(pts_3d(:,i))'];
        A(2*i,:) = [zeros(1,4) hset(pts_3d(:,i))' -pts_2d(2, i)*hset(pts_3d(:,i))'];
    end

    % SVD Solution
    [U_svd, S_svd, V_svd] = svd(A);
    p = V_svd(:,end);
    P_cal = reshape(p, 4, 3)';

    % Factor to scale the camera matrix
    b = P(3,4)/P_cal(3,4);
    P_cal = b*P_cal;

    error = P-P_cal;
    error_sum = sum(norm(error));

    % DeS_svdomposition of the Camera Matrix
    [K, R, t] = proj_decomp(P);

    % Camera reference frame to world reference frame
    t = -inv(R)*t;
    R = inv(R);
    
    % Rotation Vector and Angle
    [u, alpha] = rotation_vector(R);

    figure(201)
    plot3(pts_3d(1, :), pts_3d(2, :), pts_3d(3, :), 'o')
    hold on;
    draw_camera(P_cal);
    draw_frame([R t]);
    axis equal; grid on; box on
    title('3D Points and Estimated Camera Pose');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    hold off;
    
    figure(202)
    plot(pts_2d(1,:), pts_2d(2,:), 'ro')
    axis equal; grid on; box on
    title('2D Projected Points');
    xlabel('X (pixels)'); ylabel('Y (pixels)');

end

%------------- END OF MAIN FUNCTION --------------