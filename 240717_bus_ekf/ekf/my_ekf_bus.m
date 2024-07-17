function my_ekf_bus(buspath)

% x,y,th list of the bus
if nargin < 1
    load('../../data/buspath4.mat')
end

% phi list for plot input only
load('../../data/v_phi4.mat');
phi=v_phi_hist(:,2);

% follow inputs: 0 follow, 2 not follow
follow=zeros(1,length(buspath));
follow(80:83)= 2*ones(1,4);
follow(120:123)= 2*ones(1,4);
follow(160:163)= 2*ones(1,4);
follow(192:195)= 2*ones(1,4);

%VRML adjustments and time initialization
xytheta= buspath';
xytheta(3,:)= (xytheta(3,:)+pi/2);
time= [1:length(buspath)];

%plot real path
figure(1); clf; hold on
h=plot(xytheta(1,:),xytheta(2,:),'*-');
set(h,'linewidth',2)
for i=1:size(xytheta,2)
   draw_bus(xytheta(:,i),phi(i));
end
axis equal
title('Unfiltered robot trajectory [dm]')
text(xytheta(1,1),xytheta(2,1), ' \leftarrow INI', 'FontSize', 18)
text(xytheta(1,end),xytheta(2,end), ' \leftarrow END', 'FontSize', 18)

%EKF
obs= xytheta(1:2,:); %just x and y observable
%est - EKF estimation, P - covariance matrix
[est, P]= apply_EKF(obs, time, follow);

%plot estimated path and ellipse
figure(2); clf; hold on
h=plot(obs(1,:),obs(2,:),'.-');
%h=[h plot(est(1,:),est(2,:),'m.-')];
set(h,'linewidth',2)
for i=1:size(est,2)
   draw_bus(est(1:3,i), est(5,i), 1)
   if i~=1
       plot_ellipse(P{i}(1:2,1:2),est(1:2,i),'r');
   end
end
axis equal
title('Unfiltered and EKF filtered robot trajectory [dm]')
text(obs(1,1),obs(2,1), ' \leftarrow INI', 'FontSize', 18)
text(obs(1,end),obs(2,end), ' \leftarrow END', 'FontSize', 18)
legend('odometry', 'XY sensor')

function [est, P] = apply_EKF(obs, timeInst, follow)

est= zeros(5, size(obs,2));
P= cell(1,size(obs,2));

% EKF initialization

[est(:,1), P{1}]= ekf_bus(obs(:,1), timeInst(1), [], 1);

% filter...
%
for i=2:size(est,2),
   %
   [est(:,i),P{i}]= ekf_bus(obs(:,i), timeInst(i), P{i-1}, follow(i));
   %
end

