function BusArray=bus_ini(NumBus)

%BUS_INI - Given a number of buses, initializes a structure with the
%buses's properties.
%
% Inputs:
%   NumBus[1x1] - number of buses
%
% Outputs:
%   BusArray{NumBus} - structure with the buses' properties.
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% May 2013; Last revision: 13-Aug-2013

%------------- BEGIN MAIN FUNCTION ---------------

BusArray=struct([]);
for i=1:NumBus
    BusArray(i).Path= load_path(i); %path
    BusArray(i).time= load_time(i); %starting time
    BusArray(i).inside= [0 0]; %flag to know if the bus is inside the park now and if it was inside the park in the time instant before
end

%------------- END OF MAIN FUNCTION --------------

function path=load_path(i)

%load_path - Loads a path
%
% Inputs:
%   i[1x1] - path number

%------------- BEGIN FUNCTION ---------------

num=sprintf('%d.mat',i);
path_loc='../data/buspath';
path_loc= [path_loc num];
load(path_loc);
path=buspath';

%------------- END OF FUNCTION --------------

function time=load_time(i)

%load_time - Loads a time
%
% Inputs:
%   i[1x1] - path number

%------------- BEGIN FUNCTION ---------------

switch i
    case 1
        time= 10;
    case 2
        time= 20;
    case 3
        time= 80;
    case 4
        time= 90;
end

%------------- END OF FUNCTION --------------