%-------------------------------------------------
%
% CONVERT_VECTOR - Converts between different rotation vector formats.
% This function handles conversions between 2D, 3D, and 4-element (axis-angle)
% rotation vector representations.
%
% Inputs:
%   op : string : Operation type ('3to2', '2to3', '4to3', '3to4').
%   x  : vector : The input vector to be converted.
%
% Outputs:
%   y  : vector : The converted vector.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% July 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function y = convert_vector(op, x)

    switch op
        case '3to2', y = x; y = y/norm(y); y = y(1:2);
        case '2to3', y = [x(1:2) sqrt(1-x(1)^2-x(2)^2)];
        case '4to3', y = [convert_vector('3to2', x(1:3)) x(4)];
        case '3to4', y = [convert_vector('2to3', x(1:2)) x(3)];
        otherwise
            error('inv op')
    end
end

%------------- END OF MAIN FUNCTION --------------