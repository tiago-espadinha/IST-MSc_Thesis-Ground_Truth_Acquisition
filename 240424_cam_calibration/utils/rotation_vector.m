%-------------------------------------------------
%
% ROTATION_VECTOR - Computes the rotation vector and angle from a rotation matrix.
% This function extracts the equivalent axis-angle representation (rotation vector and angle)
% from a given 3x3 rotation matrix.
%
% Inputs:
%   R     : matrix : A 3x3 rotation matrix.
%
% Outputs:
%   u     : vector : A 3-element unit vector representing the axis of rotation.
%   alpha : double : The rotation angle in radians.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% April 2024; Last revision: 9-September-2025
%
%------------- BEGIN FUNCTION ---------------

function [u, alpha] = rotation_vector(R)

    u = [R(3,2)-R(2,3), R(1,3)-R(3,1), R(2,1)-R(1,2)];
    u = u / norm(u);
    alpha = acos((trace(R)-1)/2);
end

%------------- END OF FUNCTION --------------