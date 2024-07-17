function [s]= wmr_bus(cmd, a1, a2)

%WMR_BUS - labmat for bus with car's motion model
%
% Inputs:
%   cmd - Choose mode
%   a1, a2 - Arguments that depend on cmd (description in the switch)
%
% Outputs:
%   s - bus status
%
% Author: José Gaspar (modified by Tiago Castanheira)
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% June 2013; Last revision: 18-June-2013

%------------- BEGIN MAIN FUNCTION ---------------

global BUS_PREV_T BUS_STATUS

% update labmate status variables
%  (simulate labamate with car model)
%
if size(BUS_STATUS,1)==0
   BUS_STATUS= [0 0 0 0 0];
end
if isempty(BUS_PREV_T)
   BUS_PREV_T= 0;
end

XYT_PREV= BUS_STATUS(1:3);
v= BUS_STATUS(4);
phi= BUS_STATUS(5);

%bus properties
L=80; %[dm]
%
currT= mytoc;
deltaT= currT-BUS_PREV_T;
%
deltaT=deltaT/10;
for i=1:10,
    [XYT,~]=car_model(deltaT,L,v,phi,XYT_PREV);
    XYT_PREV=XYT;
end
%
BUS_STATUS= [XYT(1) XYT(2) XYT(3) v phi];
BUS_PREV_T= currT;

% default to null output
%
s=[];

switch cmd
    case 0,
        % 0 initialise communications with labmate and input initial
        % position
        fprintf(1, '** wmr_bus Initialise communications\n')
        if nargin==1
            BUS_STATUS= [0 0 0 0 0];
        else
            BUS_STATUS= a1;
        end
        
    case 1,
        % 1 set linear velocity, wheel turning angle)
        fprintf(1, '** wmr_bus Set velocity and wheel angle: linVel=%g phi=%g\n', a1, a2 );
        BUS_STATUS(4)= a1;
        BUS_STATUS(5)= a2;
        
    case 2,
        % 2 zero labmate heading
        fprintf(1, '** wmr_bus Zero/reset heading\n');
        BUS_STATUS(3)= 0;
        
    case 3,
        % 3 reset
        fprintf(1, '** wmr_bus Reset\n');
        BUS_STATUS= [0 0 0 0 0];
        
    case 4,
        % 4 get status s=[heading x y vel_left vel_right]
        %
        fprintf(1, '** wmr_bus Get status\n');
        s= BUS_STATUS;
        %
        fprintf('** wmr_bus status: x=%g y=%g theta=%g v=%g phi=%g\n',s(1),s(2),s(3),s(4),s(5));
        
    case 5,
        % 5 close communications with labmate
        fprintf(1, '** wmr_bus Close communications\n');
        
    otherwise
        % unknown command ...
        fprintf(1, '** wmr_bus: unknown command: %g\n', cmd );
end

%------------- END OF MAIN FUNCTION --------------