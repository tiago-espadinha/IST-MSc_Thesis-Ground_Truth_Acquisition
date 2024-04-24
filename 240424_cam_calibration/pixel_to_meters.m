%-------------------------------------------------
%
% PIXEL_TO_METERS - Converts pixel coordinates from a VRML floor image to metric coordinates for a 3D VRML world.
% This function takes pixel coordinates (e.g., from clickpts) and scales them to real-world metric units
% based on predefined scaling factors and offsets.
%
% Inputs:
%   srcPoints      : matrix : N-by-2 matrix of pixel coordinates [x, y].
%   img_width      : double : Width of the image in pixels.
%   img_height     : double : Height of the image in pixels.
%   output_x_scale : double : Scaling factor for the X-axis in meters.
%   output_y_scale : double : Scaling factor for the Y-axis in meters.
%   offset_x       : double : X-axis offset in meters.
%   offset_y       : double : Y-axis offset in meters.
%
% Outputs:
%   x_out          : vector : Converted X-coordinates in meters.
%   y_out          : vector : Converted Y-coordinates in meters.
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
%------------- BEGIN MAIN FUNCTION ---------------

function [x_out, y_out] = pixel_to_meters(srcPoints, img_width, img_height, output_x_scale, output_y_scale, offset_x, offset_y)

    % Output 2D Reference: x, -y
    x_out = output_x_scale * (srcPoints(:,1) ./ img_width - 0.5) - offset_x;
    y_out = -output_y_scale * (srcPoints(:,2) ./ img_height - 0.5) - offset_y;

end

%------------- END OF MAIN FUNCTION --------------