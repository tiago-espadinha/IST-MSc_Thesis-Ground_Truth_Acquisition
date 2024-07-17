function trackbus= followmanager(BusArray, NumBus, NumCam)

global waitList

%Check if empty list
aux=max(waitList(:,1));
if aux<0
    aux= -1*aux;
else
    aux= 0;
end

% Entering or leaving the park
for bus=1:NumBus
    %New bus inside park?
    if BusArray(bus).inside(1) == 1 && BusArray(bus).inside(2) == 0%if it is inside the park but previously wasn't
        camera= max(waitList(:,2)); %which camera?
        if camera == NumCam %if all cameras assigned
            camera= 0; %don't assign a camera
        else
            camera= camera + 1; %assign a camera
        end
        waitList(bus,:) = [max(waitList(:,1))+1+aux, camera]; %bus goes to the end of the line
    end %else, ignore
    
    %New bus left the park?
    if BusArray(bus).inside(1) == 0 %if it is outside the park
        if waitList(bus,1) > 0 %if previously was in the park
            prevplace= waitList(bus,1);
            if waitList(bus,2) > 0
                cam_busleft= waitList(bus,2);
            end
            waitList(bus,:) = [-1 0]; %bus gets out of the line
            for i=1:NumBus
                if waitList(i,1) > prevplace
                    waitList(i,1)= waitList(i,1) - 1;
                end
            end
            for i=1:NumCam
                place= find(waitList(:,2) == i);
                if isempty(place)
                    next_bus_list=waitList(find(waitList(:,2)==0 & waitList(:,1)>0));
                    if ~isempty(next_bus_list)
                        busswap= find(waitList(:,1)==min(next_bus_list));
                        waitList(busswap,2)= cam_busleft;
                    end
                end
            end
                
        end %else, ignore
    end
end

%Update list
waitList(:,1)= waitList(:,1)-1; %Decrease position in line
last= find(waitList(:,1)==0); %Find previous first in line
camswap=waitList(last,2);
if ~isempty(last) %if there are buses inside
    waitList(last,:)= [max(waitList(:,1))+1, 0]; %Put him in the end of the line
    busswap= find(waitList(:,1)==min(waitList(find(waitList(:,2)==0 & waitList(:,1)>0)))); %find the first bus in line that doesn't have a camera assigned
    waitList(busswap,2)= camswap; %Assign him the camera
end

%Output

trackbus= zeros(1, NumCam);
for cam=1:NumCam
    if isempty(find(waitList(:,2)==cam))
        break;
    end
    trackbus(cam)=find(waitList(:,2)==cam);
    if trackbus(cam) == 0;
        trackbus(cam)= -1;
    end
end
    