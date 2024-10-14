%-------------------------------------------------
%
% CALCULATE_CENTER - Calculates the vehicle center based on wheel coordinates.
% This function determines the vehicle's center point in pixels by calculating
% the midpoint of the two wheels and offsetting it by half the vehicle's width.
%
% Inputs:
%   wheel_coord : matrix : 2x2 matrix with wheel coordinates [x1 y1; x2 y2].
%
% Outputs:
%   center      : vector : 1x2 vector with the center coordinates [x, y].
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function center = calculate_center(wheel_coord)

    % Vehicle parameters
    car_width = 1.508; % Vehicle width in meters
    scaling_factor = 1080 / 27; % Scaling factor to convert meters to pixels
    car_width_px = car_width * scaling_factor;

    % Angle of the line connecting the wheels
    alpha = atan2(wheel_coord(1,2) - wheel_coord(2,2), wheel_coord(1,1) - wheel_coord(2,1));
    alpha = alpha + pi/2; 

    % Midpoint of the wheels
    mid_x = (wheel_coord(1,1) + wheel_coord(2,1)) / 2;
    mid_y = (wheel_coord(1,2) + wheel_coord(2,2)) / 2;

    % Offset by half the vehicle width to find the center
    x_center = mid_x - cos(alpha) * car_width_px / 2;
    y_center = mid_y - sin(alpha) * car_width_px / 2;
    center = [x_center, y_center];
end

%------------- END OF MAIN FUNCTION --------------