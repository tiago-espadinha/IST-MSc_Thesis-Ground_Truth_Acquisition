function draw_bus(pose, phi, color)
%DRAW_BUS - Draws a bus and its wheels in an open plot.
%
% Inputs:
%   pose - [x y theta]
%   phi - angle of the wheels in relation to theta
%   color - color switch
%
% Original author: Nuno Ribeiro
% Altered by: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior T�cnico
% August 2013; Last revision: 12-Aug-2013

%------------- BEGIN MAIN FUNCTION ---------------

%Color bus option
if nargin<3
    bus_body= [0 0 1];
    bus_wheel_f= [0 0.8 1];
    bus_wheel_b= [0 0.8 1];
end

if nargin>2
    switch color
        case 0
            bus_body= [0 0 1];
            bus_wheel_f= [0 0.8 1];
            bus_wheel_b= [0 0.8 1];
        case 1
            bus_body= [0 0 0];
            bus_wheel_f= [1 0 0];
            bus_wheel_b= [1 0 1];
    end
end

%Data
L=80; %Distance between axel shafts
A=20; %Axel shaft length
w_rad= 6; %Wheel radius
w_width= 5; %Wheel width
front=10; %Distance between front axel shaft and the front of the bus
back=10; %Distance between back axel shaft and the back of the bus

%Center of left wheels
XF_l(1)=pose(1);
XF_l(2)=pose(2)+A/2;
XR_l(1)=pose(1)-L;
XR_l(2)=pose(2)+A/2;

%Center of right wheels
XF_r(1)=pose(1);
XF_r(2)=pose(2)-A/2;
XR_r(1)=pose(1)-L;
XR_r(2)=pose(2)-A/2;

%Vertices of left, front wheel
vertF_l = [XF_l(1)-w_rad XF_l(2)-w_width/2 1;
        XF_l(1)-w_rad XF_l(2)+w_width/2 1;
        XF_l(1)+w_rad XF_l(2)+w_width/2 1;
        XF_l(1)+w_rad XF_l(2)-w_width/2 1]';
    
%Vertices of right, front wheel
vertF_r = [XF_r(1)-w_rad XF_r(2)-w_width/2 1;
        XF_r(1)-w_rad XF_r(2)+w_width/2 1;
        XF_r(1)+w_rad XF_r(2)+w_width/2 1;
        XF_r(1)+w_rad XF_r(2)-w_width/2 1]';
    
%Vertices of left, back wheel
vertR_l = [XR_l(1)-w_rad XR_l(2)-w_width/2 1;
        XR_l(1)-w_rad XR_l(2)+w_width/2 1;
        XR_l(1)+w_rad XR_l(2)+w_width/2 1;
        XR_l(1)+w_rad XR_l(2)-w_width/2 1]';
    
%Vertices of right, back wheel
vertR_r = [XR_r(1)-w_rad XR_r(2)-w_width/2 1;
        XR_r(1)-w_rad XR_r(2)+w_width/2 1;
        XR_r(1)+w_rad XR_r(2)+w_width/2 1;
        XR_r(1)+w_rad XR_r(2)-w_width/2 1]';
    
%Vertices of the bus
vert_car=[pose(1)-L-back pose(2)-A/2 1
      pose(1)-L-back pose(2)+A/2 1
      pose(1)+front pose(2)+A/2 1
      pose(1)+front pose(2)-A/2 1]';
  
  
%Computation of left, front wheel's position  
vert=rotate_around_point(vertF_l,pose(1:2), pose(3));
vert=rotate_around_point(vert,[(vert(1,1)+vert(1,3))/2 (vert(2,2)+vert(2,4))/2],phi);

%Plot of left, front wheel
vert_draw=vert;
vert_draw(:,5)=vert(:,1);
line(vert_draw(1,:),vert_draw(2,:),'Color', bus_wheel_f);

    
%Computation of right, front wheel's position   
vert=rotate_around_point(vertF_r, pose(1:2), pose(3));
vert=rotate_around_point(vert,[(vert(1,1)+vert(1,3))/2 (vert(2,2)+vert(2,4))/2],phi);

%Plot of right, front wheel
vert_draw=vert;
vert_draw(:,5)=vert(:,1);
line(vert_draw(1,:),vert_draw(2,:),'Color', bus_wheel_f);

    
%Computation of left, back wheel's position   
vert=rotate_around_point(vertR_l, pose(1:2), pose(3));

%Plot of left, back wheel
vert_draw=vert;
vert_draw(:,5)=vert(:,1);
line(vert_draw(1,:),vert_draw(2,:),'Color', bus_wheel_b);


%Computation of right, back wheel's position  
vert=rotate_around_point(vertR_r, pose(1:2), pose(3));

%Plot of right, back wheel
vert_draw=vert;
vert_draw(:,5)=vert(:,1);
line(vert_draw(1,:),vert_draw(2,:),'Color', bus_wheel_b);


%Computation of bus' position  
vert=rotate_around_point(vert_car ,pose(1:2), pose(3));

%Plot of bus
vert_draw=vert;
vert_draw(:,5)=vert(:,1);
line(vert_draw(1,:),vert_draw(2,:),'Color', bus_body);

%------------- END OF MAIN FUNCTION ---------------


function [vert_out]= rotate_around_point(vert_in, point, angle)
%rotate_around_point - Function that rotates a set o vertices around a point
%
% Inputs:
%   vert_in - matrix with vertices:
%       [x1 x2 x3 ...
%        y1 y2 y3 ...
%        1  1  1  ...]
%   point - rotation center
%   angle - rotation angle

%------------- BEGIN FUNCTION ---------------

Torigin2point=eye(3,3);
Torigin2point(1,3)=-point(1);
Torigin2point(2,3)=-point(2);

ROT=[cos(angle) -sin(angle)
    sin(angle) cos(angle)];

R0=eye(3,3);
R0(1:2,1:2)=ROT;

ROTfinal=inv(Torigin2point)*R0*Torigin2point;

vert_out=ROTfinal*vert_in;

%------------- END OF FUNCTION --------------