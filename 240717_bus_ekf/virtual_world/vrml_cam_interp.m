function vrml_fov= vrml_cam_interp(sud)

%VRML_CAM_INTERP - Calculates the VRML fieldOfView angle from the the
%intrinsic parameter alpha (horizontal and vertical focal length of the
%camera in pixels)
%
% Inputs:
%   sud - horizontal uv scaling (intrinsic parameters matrix K)
%
% Outputs:
%   vrml_fov - VRML fieldOfView value
%
% Other m-files required: none
% Subfunctions: convert_intrinsic_to_vrml, table_data
% MAT-files required: none
%
% Author: José Gaspar
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN CODE ---------------

if nargin<1
    %vrml_fov= convert_intrinsic_to_vrml(1000);
    table_data
    return
end

vrml_fov= convert_intrinsic_to_vrml(sud);

return


function vrml_fov= convert_intrinsic_to_vrml(sud)
x= table_data;
tbl= [1./x(:,1) mean(x(:,2:3),2)];
tbl= [0 0; tbl(end:-1:1,:)];
fovinv= interp1(tbl(:,2), tbl(:,1), sud);
vrml_fov= 1/fovinv;
return


function x= table_data
x= [
    0.15 2355.2 2369.2 2427.2 2405.3
    0.30 1308.6 1315.5 1246.1 1230.9
    0.60 571.4 582.1 624.4 615.9
    1.20 279.5 279.0 282.2 279.5
    1.60 187.7 186.9 187.6 187.2
    ];

if nargout<1
    figure(301)
    plot(x(:,1), x(:,2:5), '.-')
    xlabel('VRML fov');
    legend('s_u(ver2)', 's_v(ver2)', 's_u(Bouguet)', 's_v(Bouguet)')
    figure(302)
    plot(1./x(:,1), x(:,2:5), '.-')
    xlabel('inverse of VRML fov');
    legend({'s_u(ver2)', 's_v(ver2)', 's_u(Bouguet)', 's_v(Bouguet)'}, 'Location', 'SouthEast')
end

%------------- END OF CODE --------------