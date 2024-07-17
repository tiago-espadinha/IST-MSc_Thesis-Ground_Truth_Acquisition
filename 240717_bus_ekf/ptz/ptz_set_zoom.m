function Camera=ptz_set_zoom(Camera,zoom)

%PTZ_SET_ZOOM - Sets zoom in the VRML world
%
% Inputs:
%   Camera - structure with the camera data
%   zoom - lens' opening angle in rad
%
% Outputs:
%   Camera - structure with the camera data
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior T�cnico
% April 2013; Last revision: 26-Apr-2013

%------------- BEGIN MAIN FUNCTION ---------------

zoom= deg2rad(zoom);

%Computation of matrix K
W=864; %Width of image in pixels
H=525; %Hight of image in pixels

u0=(W+1)/2;
v0=(H+1)/2;
su=H/(2*tan(zoom/2));
sv=su; %squared pixels

K=zeros(3);
K(1,1)=su;
K(2,2)=sv;
K(1,3)=u0;
K(2,3)=v0;
K(3,3)=1;

%Test if K is correct

% if su<2400 && su>2300
%     fprintf('su=%d, alpha=%d\n',su,zoom);
% end

%Update data
Camera.K=K;

%VRML
vrml_world_set(1,'camera',Camera.num,0,zoom);
vrml_world_set(2,'camera',Camera.num,0,zoom);

% %gr�fico do zoom
% zoom1=zoom(1);
% zoom2=zoom(2);
% err=abs(zoom1-zoom2);
% if isempty(zoomarray)
%     zoomarray=[zoom1;zoom2;err];
% else
%     zoom_aux=[zoom1;zoom2;err];
%     zoomarray=[zoomarray, zoom_aux];
% end
% 
% figure(23)
% hold on
% plot(zoomarray(1,:),'.');
% plot(zoomarray(2,:),'.r');
% plot(zoomarray(3,:),'.g');
% hold off

% figure(23)
% plot(my_log(zoom))
% 
% return
% 
% function y=my_log(x)
% 
% persistent Mylog Mylog_last_t
% 
% if nargout>0
%     y=Mylog;
%     return
% end
% 
% if isempty(Mylog_last_t) || clock(6)-Mylog_last_t>5
%     Mylog= [];
% end
% 
% Mylog=[Mylog x];

%------------- END OF MAIN FUNCTION --------------