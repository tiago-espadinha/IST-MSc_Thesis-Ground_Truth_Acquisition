%-------------------------------------------------
%
% NORMALIZE_PLANE - Aligns a set of calibrated poses to the XY plane.
% This function takes a set of 3D poses, calculates the best-fit plane for
% them, and then computes and applies a rigid transformation to align this
% plane with the world's XY plane.
%
% Inputs:
%   edge_output : struct : Array of calibration results.
%   edge_input  : struct : Array of initial frame data and pose guesses.
%   mode        : string : The calibration mode ('6dof' or '7dof').
%
% Outputs:
%   edge_output_algn : struct : The input 'edge_output' with poses transformed.
%   edge_input_algn  : struct : The input 'edge_input' with initial guesses transformed.
%
% Other m-files required: display_plane.m, eul2rotm.m, rotm2eul.m, axang2rotm.m, vrrotvec.m,
%   display_vehicle.m, display_camera.m, save_results.m
% Subfunctions: calculate_plane_transform, apply_transform, apply_transform_to_input
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [edge_output_algn, edge_input_algn] = normalize_plane(edge_output, edge_input, mode)

    % Visualize the initial results
    all_positions = vertcat(edge_output(:).car_position);

    figure(602); clf; hold on;
    title('Initial Calibrated Poses');
    for i = 1:numel(edge_output)
        display_vehicle(edge_output(i).car_position, edge_output(i).car_rotation);
    end
    display_camera(edge_output(end).cam_position, edge_output(end).cam_rotation);
    [plane_normal, ~] = display_plane(all_positions);
    view(3); hold off;
    save_results(['initial_poses_', mode]);
    
    % Calculate the rotation and translation needed to align the plane
    origin_point = all_positions(end, :);
    T = calculate_plane_transform(plane_normal, origin_point);

    % Apply transformation to all poses
    edge_output_algn = edge_output;
    for i = 1:numel(edge_output_algn)
        [edge_output_algn(i).car_position, edge_output_algn(i).car_rotation] = ...
            apply_transform(edge_output(i).car_position, edge_output(i).car_rotation, T);
    end
    
    % Apply transformation to the camera pose
    [edge_output_algn(end).cam_position, edge_output_algn(end).cam_rotation] = ...
        apply_transform(edge_output(end).cam_position, edge_output(end).cam_rotation, T);

    % Apply transformation to the initial guess data
    edge_input_algn = apply_transform_to_input(edge_input, T);

    % Visualize the Aligned Results
    figure(603); clf; hold on;
    title('Aligned Poses');
    for i = 1:numel(edge_output_algn)
        display_vehicle(edge_output_algn(i).car_position, edge_output_algn(i).car_rotation);
    end
    display_camera(edge_output_algn(end).cam_position, edge_output_algn(end).cam_rotation);
    display_plane(vertcat(edge_output_algn(:).car_position));
    view(3); hold off;
    save_results(['aligned_poses_', mode]);
end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
%
% CALCULATE_PLANE_TRANSFORM - Calculates the transformation to align a plane with the XY plane.
%
% Inputs:
%   plane_normal : array : The normal vector of the plane to be aligned.
%   origin_point : array : The point that will become the new origin.
%
% Outputs:
%   T : struct : A struct containing the rotation matrix and translation vector.
%
%------------- BEGIN FUNCTION ---------------

function T = calculate_plane_transform(plane_normal, origin_point)
    % Calculates the transformation to align a plane with the XY plane.
    target_normal = [0 0 1];
    
    % Calculate rotation from the plane's normal to the Z-axis
    rot_matrix = vrrotvec(plane_normal, target_normal);
    T.rotation = axang2rotm(rot_matrix);
    
    % Calculate translation to move the origin_point to the new origin (0,0,0)
    rotated_origin = T.rotation * origin_point';
    T.translation = -rotated_origin;
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
%
% APPLY_TRANSFORM - Applies a rigid body transformation to a single pose.
%
% Inputs:
%   position_in : array : The original position vector [x, y, z].
%   rotation_in : array : The original rotation (Euler angles).
%   T           : struct: The transformation struct with .rotation and .translation.
%
% Outputs:
%   position_out : array : The transformed position vector.
%   rotation_out : array : The transformed rotation (Euler angles).
%
%------------- BEGIN FUNCTION ---------------

function [position_out, rotation_out] = apply_transform(position_in, rotation_in, T)
    % Applies a rigid body transformation to a single pose.
    position_out = (T.rotation * position_in' + T.translation)';
    rotation_out = rotm2eul(T.rotation * eul2rotm(rotation_in));
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
%
% APPLY_TRANSFORM_TO_INPUT - Applies the transformation to the initial guesses in the edge_input struct.
%
% Inputs:
%   edge_in : struct : The original edge_input struct array.
%   T       : struct : The transformation struct.
%
% Outputs:
%   edge_out : struct : The transformed edge_input struct array.
%
%------------- BEGIN FUNCTION ---------------

function edge_out = apply_transform_to_input(edge_in, T)

    edge_out = edge_in;
    for i = 1:numel(edge_out)
        position_in = edge_out(i).car_position;
        rotation_in = edge_out(i).car_rotation;
        [edge_out(i).car_position, edge_out(i).car_rotation] = apply_transform(position_in, rotation_in, T);
    end
end

%------------- END OF FUNCTION --------------