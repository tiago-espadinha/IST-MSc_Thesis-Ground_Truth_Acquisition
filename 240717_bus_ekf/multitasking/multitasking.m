function trackBus= multitasking(NumBus, NumCam, ptz_dist, A)

if nargin == 0
    NumBus= 4;
    NumCam= 2;
    A= [300; 700; 400; 100];
    ptz_dist= [25 30 2 24 33 5;
        65 22 13 45 32 35;
        33 75 21 45 23 83;
        32 34 53 21 54 35];
end

maxAbus= zeros(NumCam,1);
assign= zeros(NumCam,1);
trackBus= -1*ones(NumCam,1);

%which [NumCam] buses with biggest uncertainty?
sortedA= sort(A,'descend');

for cam=1:NumCam
    [aux, ~]= find(A == sortedA(cam));
    maxAbus(cam)=aux(1);
    A(aux(1))= -1*inf;
end

%which camera is closer to which bus?

[M,N]=size(ptz_dist);
ang_dist=zeros(M,N/3);

%pan, tilt and zoom speed are the same
for bus=1:NumBus
    for cam=1:NumCam
        ang_dist(bus,cam)=max(ptz_dist(bus,3*cam-2:3*cam));
    end
end



for cam=1:NumCam
    which_dist= min(ang_dist(maxAbus(cam),:));
    if which_dist ~= inf
        which_cam= find(ang_dist(maxAbus(cam),:) == which_dist);
        which_cam=which_cam(1);
        trackBus(which_cam)= maxAbus(cam);
        ang_dist(:,which_cam)=inf*ones(NumBus,1);
    end
end


