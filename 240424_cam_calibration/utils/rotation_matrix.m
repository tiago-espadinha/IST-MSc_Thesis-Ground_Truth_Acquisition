%-------------------------------------------------
%
% ROTATION_MATRIX - Computes the rotation matrix from a rotation vector and angle.
% This function implements Rodrigues' rotation formula to generate a 3x3 rotation matrix
% given a unit rotation vector and a rotation angle.
%
% Inputs:
%   u     : vector : A 3-element unit vector representing the axis of rotation.
%   alpha : double : The rotation angle in radians.
%
% Outputs:
%   R     : matrix : A 3x3 rotation matrix.
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

function R = rotation_matrix(u, alpha)

    c = cos(alpha);
    s = sin(alpha);
    t = 1 - c;

    R = [c + u(1)^2*t, u(1)*u(2)*t - u(3)*s, u(1)*u(3)*t + u(2)*s;
         u(2)*u(1)*t + u(3)*s, c + u(2)^2*t, u(2)*u(3)*t - u(1)*s;
         u(3)*u(1)*t - u(2)*s, u(3)*u(2)*t + u(1)*s, c + u(3)^2*t];
end

%------------- END OF FUNCTION --------------