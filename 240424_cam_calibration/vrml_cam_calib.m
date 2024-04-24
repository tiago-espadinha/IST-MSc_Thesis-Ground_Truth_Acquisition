%-------------------------------------------------
%
% VRML_CAM_CALIB - Obtains a camera matrix from matching keypoints between an image and VRML 3D points.
% This function calculates the camera projection matrix (P) using a Least Squares Estimation (LSE)
% approach based on corresponding 2D image points and 3D world points. It then decomposes P
% into intrinsic (K), rotation (R), and translation (t) components, and derives the rotation
% vector (u) and angle (alpha).
%
% Inputs:
%   image_path : string : Path to the image file.
%   pts_3d     : matrix : 3xN matrix of 3D points in VRML world coordinates.
%   pts_2d     : matrix : 2xN matrix of 2D points in image coordinates.
%
% Outputs:
%   u         : vector  : Rotation vector (unit vector) representing camera orientation.
%   alpha     : double  : Rotation angle in radians representing camera orientation.
%   t         : vector  : Translation vector from world to camera coordinates.
%   R         : matrix  : Rotation matrix from world to camera coordinates.
%   error_sum : double  : Sum of errors between projected 2D points and calculated 2D points.
%   error     : vector  : Vector of individual errors for each point.
%   K         : matrix  : Intrinsic camera matrix.
%   P         : matrix  : Camera projection matrix.
%
% Other m-files required: hset.m, hrem.m, proj_decomp.m, rotation_vector.m, draw_camera.m, draw_frame.m, clickpts.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% April 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [u, alpha, t, R, error_sum, error, K, P] = vrml_cam_calib(image_path, pts_3d, pts_2d)

    n_pts = size(pts_3d, 2);
    
    use_clickpts = false;
    if nargin < 3 || isempty(pts_2d)
        use_clickpts = true;
    end

    % Display 2D points on image
    figure(211)
    imshow(image_path);
    hold on;
    if use_clickpts
        pts_2d = clickpts.';
    else
        plot(pts_2d(1,:), pts_2d(2,:), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
    end
    title('2D Points on Image');
    hold off;

    % Camera Calibration with LSE
    A = zeros(2*n_pts, 12);

    % LSE System for each pair of points
    for i=1:n_pts
        A(2*i-1,:) = [hset(pts_3d(:,i))' zeros(1,4) -pts_2d(1, i)*hset(pts_3d(:,i))' ];
        A(2*i,:) = [zeros(1,4) hset(pts_3d(:,i))' -pts_2d(2, i)*hset(pts_3d(:,i))' ];
    end

    % SVD Solution
    [U_svd, S_svd, V_svd] = svd(A);
    p = V_svd(:,end);
    P = reshape(p, 4, 3)';

    % Error Computation
    pts_2d_new = P * hset(pts_3d);
    pts_2d_new = hrem(pts_2d_new);
    e = pts_2d - pts_2d_new;
    error = zeros(1, n_pts);

    for i=1:n_pts
        error(i) = norm(e(:,i));
    end
    error_sum = sum(error, "all");

    % Decomposition of the Camera Matrix
    [K, R, t] = proj_decomp(P);

    % Camera reference frame to world reference frame
    t = -inv(R)*t;
    R = inv(R);
    
    % Rotation Vector and Angle
    [u, alpha] = rotation_vector(R);

    % Display 3D points and camera pose
    figure(212)
    plot3(pts_3d(1,:), pts_3d(2,:), pts_3d(3,:), 'r*', 'MarkerSize', 10, 'LineWidth', 2);
    hold on;
    scale = struct('scale', 20);
    draw_camera(P, scale);
    draw_frame([R t]);
    box on; grid on; axis equal;
    title('3D Points and Estimated Camera Pose');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    hold off;

end

%------------- END OF MAIN FUNCTION --------------