function xyt_bgs= backgndsub(Camera, framearray, xyt_pred)

L= 80;

%Background subtraction
im_org= double(framearray{1}); %Original
im_bck= double(framearray{2}); %Background

bgs_org= sum(abs(im_org-im_bck),3) ~= 0;

%Compute starting point
%xyt_start= xyt+ [10 20 pi/5];
xyt_start(1:2)= start_point(bgs_org, Camera, xyt_pred(1:2));

%Move from center of the bus to the axel shaft's
xyt_start(3)= xyt_pred(3) - pi/2;
xyt_start(1)= xyt_start(1) - L/2*sin(xyt_start(3));
xyt_start(2)= xyt_start(2) + L/2*cos(xyt_start(3));
bus= Camera.bus;

%fminsearch
xyt_bgs= fminsearch(@(xyt) bus_match_bgs(bgs_org, im_bck, bus, xyt), xyt_start);

%test if bus is backwards
%xyt_bgs= backwards_tst(im_org, xyt_est, L, bus);
% th_bgs= conv_ang(xyt_bgs(3));
% th_pred= conv_ang(xyt_pred(3));
% 
% if min(2*pi - abs(th_bgs-th_pred), abs(th_bgs-th_pred)) > 110*pi/180
%     xyt_bgs_b(1)= xyt_bgs(1) - L*sin(xyt_bgs(3)+pi);
%     xyt_bgs_b(2)= xyt_bgs(2) + L*cos(xyt_bgs(3)+pi);
%     xyt_bgs_b(3)= xyt_bgs(3) + pi;
%     xyt_bgs=xyt_bgs_b;
% end

%convert to same format [-pi pi]
%xyt_bgs(3)= conv_ang(xyt_bgs(3)+pi/2);
xyt_bgs(3)= xyt_bgs(3)+pi/2;

xyt_bgs= xyt_bgs';



function F= bus_match_bgs(bgs_org, im_bck, bus, xyt)

global world_fig

% Set bus with xyt
vrml_world_set(2, 'bus', bus, xyt);

%Take picture
im_tst= capture(world_fig{2});
im_tst= double(im_tst);

%Apply background subtraction
bgs_tst= sum(abs(im_tst-im_bck),3) ~= 0;

%Compute interseption
inters= bgs_tst.* bgs_org;

%Calculate area
area_int= sum(sum(inters));
area_tst= sum(sum(bgs_tst));

%Calculate compatibility racio
F= 1 - area_int/area_tst;


function xyt_start= start_point(bgs_org, Camera, xy_pred)

Z= 10;

%Erase noise
bgs_org=bwmorph(bgs_org,'dilate',2);
bgs_org=bwmorph(bgs_org,'erode',4);
bgs_org=bwmorph(bgs_org,'dilate',2);

%Label the buses
[labels,num]=bwlabel(bgs_org);

bgs_new= cell(num,1);
pts= cell(num,1);
pos= zeros(num,2);
dist= zeros(num,1);
for i=1:num
    %Find bus
    bgs_new{i}= (labels == i);
    
    %Computation of medium point in the image
    [pts{i}(:,1),pts{i}(:,2)]= find(bgs_new{i} == 1);
    m(2,1)= mean(pts{i}(:,1));
    m(1,1)= mean(pts{i}(:,2));
    m=hset(m);
    
    %Add 180º rotation around axis x
    Raux=eye(3);
    Raux(2,2)= -1;
    Raux(3,3)= -1;
    
    %Projection matrix
    PI= Camera.K* Raux* [Camera.R, Camera.t];
    
    %Projection center C
    C= -1*inv(PI(:,1:3))*PI(:,4);
    
    %Point in infinity D
    D= inv(PI(:,1:3))*m;
    
    %Point in world
    alpha= (Z - C(3))/D(3);
    X= C(1) + alpha*D(1);
    Y= C(2) + alpha*D(2);
    
    pos(i,:)=[X, Y];
    m=hrem(m);
    
    %Distance to prediction
    dist(i,:)=sqrt((X-xy_pred(1))^2+(Y-xy_pred(2))^2);
end

minim= find(dist == min(dist));
xyt_start= pos(minim,:);


function xyt_est= backwards_tst(im_org, xyt_est, L, bus)

global world_fig

%original estimated position
framearray{2}= capture(world_fig{2});
aux= double(framearray{2});
bgs_est= sum(abs(im_org-aux),3) ~= 0;
pix_est= length(find(bgs_est == 1));

%turn the bus around
xyt_est_b(1)= xyt_est(1) - L*sin(xyt_est(3)+pi);
xyt_est_b(2)= xyt_est(2) + L*cos(xyt_est(3)+pi);
xyt_est_b(3)= xyt_est(3) + pi;
vrml_world_set(2, 'bus', bus, xyt_est_b);

%estimated position backwards
aux= capture(world_fig{2});
aux= double(aux);
bgs_est_b= sum(abs(im_org-aux),3) ~= 0;
pix_est_b= length(find(bgs_est_b == 1));
    
if pix_est_b < pix_est
    xyt_est=xyt_est_b;
end

function ang= conv_ang(ang)

%first convert angle to the range of [-2pi 2pi]
cnt= ang/(2*pi);

if cnt > 1 || cnt <= -1
    if cnt > 1
        ang= (cnt - floor(cnt))*2*pi;
    elseif cnt <= -1
        ang= (cnt - ceil(cnt))*2*pi;
    end
end

%then convert angle to the range of [-pi pi]
cnt= ang/pi;

if cnt > 1 || cnt <= -1
    if cnt > 1
        ang= (cnt - floor(cnt))*pi-pi;
    elseif cnt <= -1
        ang= (cnt - ceil(cnt))*pi+pi;
    end
end