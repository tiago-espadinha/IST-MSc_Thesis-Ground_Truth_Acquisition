%-------------------------------------------------
%
% DRAW_CAR - Draws a 2D representation of a car.
% This function plots the body and wheels of a car on the current figure
% based on its pose and wheel angle.
%
% Inputs:
%   pose  : vector : 3x1 vector of the car's pose [x; y; theta].
%   phi   : double : Steering angle of the front wheels in radians.
%   color : int    : Color code for the car (0 for blue, 1 for black).
%
% Outputs:
%   None
%
% Other m-files required: None
% Subfunctions: rotate_around_point
% MAT-files required: None
%
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 21-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function draw_car(pose, phi, color)

    if nargin<3
        car_body = [0 0 1];
        car_wheel_f = [0 0.8 1];
        car_wheel_b = [0 0.8 1];
    end

    if nargin>2
        switch color
            case 0
                car_body = [0 0 1];
                car_wheel_f = [0 0.8 1];
                car_wheel_b = [0 0.8 1];
            case 1
                car_body = [0 0 0];
                car_wheel_f = [1 0 0];
                car_wheel_b = [1 0 1];
        end
    end

    % Vehicle dimensions
    L = 2.2; % Distance between axel shafts
    A = 1.5; % Axel shaft length
    w_rad = .6; % Wheel radius
    w_width = .5; % Wheel width
    front = 1.0; % Distance between front axel shaft and the front of the bus
    back = 1.0; % Distance between back axel shaft and the back of the bus

    % Center of left wheels
    XF_l(1) = pose(1);
    XF_l(2) = pose(2)+A/2;
    XR_l(1) = pose(1)-L;
    XR_l(2) = pose(2)+A/2;

    % Center of right wheels
    XF_r(1) = pose(1);
    XF_r(2) = pose(2)-A/2;
    XR_r(1) = pose(1)-L;
    XR_r(2) = pose(2)-A/2;

    % Vertices of left, front wheel
    vertF_l = [XF_l(1)-w_rad XF_l(2)-w_width/2 1;
            XF_l(1)-w_rad XF_l(2)+w_width/2 1;
            XF_l(1)+w_rad XF_l(2)+w_width/2 1;
            XF_l(1)+w_rad XF_l(2)-w_width/2 1]';
        
    % Vertices of right, front wheel
    vertF_r = [XF_r(1)-w_rad XF_r(2)-w_width/2 1;
            XF_r(1)-w_rad XF_r(2)+w_width/2 1;
            XF_r(1)+w_rad XF_r(2)+w_width/2 1;
            XF_r(1)+w_rad XF_r(2)-w_width/2 1]';
        
    % Vertices of left, back wheel
    vertR_l = [XR_l(1)-w_rad XR_l(2)-w_width/2 1;
            XR_l(1)-w_rad XR_l(2)+w_width/2 1;
            XR_l(1)+w_rad XR_l(2)+w_width/2 1;
            XR_l(1)+w_rad XR_l(2)-w_width/2 1]';
        
    % Vertices of right, back wheel
    vertR_r = [XR_r(1)-w_rad XR_r(2)-w_width/2 1;
            XR_r(1)-w_rad XR_r(2)+w_width/2 1;
            XR_r(1)+w_rad XR_r(2)+w_width/2 1;
            XR_r(1)+w_rad XR_r(2)-w_width/2 1]';
        
    % Vertices of the car
    vert_car = [pose(1)-L-back pose(2)-A/2 1
        pose(1)-L-back pose(2)+A/2 1
        pose(1)+front pose(2)+A/2 1
        pose(1)+front pose(2)-A/2 1]';
    
    
    % Computation of left, front wheel's position  
    vert = rotate_around_point(vertF_l,pose(1:2), pose(3));
    vert = rotate_around_point(vert,[(vert(1,1)+vert(1,3))/2 (vert(2,2)+vert(2,4))/2],phi);

    % Plot of left, front wheel
    vert_draw = vert;
    vert_draw(:,5) = vert(:,1);
    line(vert_draw(1,:),vert_draw(2,:),'Color', car_wheel_f);

        
    % Computation of right, front wheel's position   
    vert = rotate_around_point(vertF_r, pose(1:2), pose(3));
    vert = rotate_around_point(vert,[(vert(1,1)+vert(1,3))/2 (vert(2,2)+vert(2,4))/2],phi);

    % Plot of right, front wheel
    vert_draw = vert;
    vert_draw(:,5) = vert(:,1);
    line(vert_draw(1,:),vert_draw(2,:),'Color', car_wheel_f);

        
    % Computation of left, back wheel's position   
    vert = rotate_around_point(vertR_l, pose(1:2), pose(3));

    % Plot of left, back wheel
    vert_draw = vert;
    vert_draw(:,5) = vert(:,1);
    line(vert_draw(1,:),vert_draw(2,:),'Color', car_wheel_b);


    % Computation of right, back wheel's position  
    vert = rotate_around_point(vertR_r, pose(1:2), pose(3));

    % Plot of right, back wheel
    vert_draw = vert;
    vert_draw(:,5) = vert(:,1);
    line(vert_draw(1,:),vert_draw(2,:),'Color', car_wheel_b);


    % Computation of car' position  
    vert = rotate_around_point(vert_car ,pose(1:2), pose(3));

    % Plot of car
    vert_draw = vert;
    vert_draw(:,5) = vert(:,1);
    line(vert_draw(1,:),vert_draw(2,:),'Color', car_body);

end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
%
% ROTATE_AROUND_POINT - Function that rotates a set o vertices around a point
%
% Inputs:
%   vert_in : matrix 3xN : vertices to be rotated   
%   point   : vector 2x1 : point around which to rotate
%   angle   : float      : angle in radians to rotate the vertices
%
% Outputs:
%   vert_out : matrx 3xN : rotated vertices
%
%------------- BEGIN FUNCTION ---------------
        
function [vert_out] = rotate_around_point(vert_in, point, angle)

    Torigin2point = eye(3,3);
    Torigin2point(1,3) = -point(1);
    Torigin2point(2,3) = -point(2);

    ROT = [cos(angle) -sin(angle)
        sin(angle) cos(angle)];

    R0 = eye(3,3);
    R0(1:2,1:2) = ROT;

    ROTfinal = inv(Torigin2point)*R0*Torigin2point;

    vert_out = ROTfinal*vert_in;

end

%------------- END OF FUNCTION --------------