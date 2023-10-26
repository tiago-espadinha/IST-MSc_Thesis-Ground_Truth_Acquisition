% Different Rotation Matrix
% https://en.wikipedia.org/wiki/Rotation_matrix#In_three_dimensions

% Fix the seed
rng(1);

K = eye(3);
t = [0; 0; 10];

% Random 3D points
M = [randn(3,30); ones(1,30)];
% M = [0 0 0 2 0 2 2 2;
%      0 0 2 0 2 2 0 2;
%      0 2 0 0 2 0 2 2;
%      1 1 1 1 1 1 1 1];

% Min and Max angle
rx = [-10, 10];
ry = [-10, 10];
rz = [-10, 10];

a_x = 0 * pi/180;
ct_x = cos(a_x);
st_x = sin(a_x);
Rx = [1 0 0; 
      0 ct_x -st_x; 
      0 st_x ct_x];

a_y = 0 * pi/180;
ct_y = cos(a_y);
st_y = sin(a_y);
Ry = [ct_y 0 st_y;
      0 1 0;
      -st_y 0 ct_y];

a_z = 0 * pi/180;
ct_z = cos(a_z);
st_z = sin(a_z);
Rz = [ct_z -st_z 0;
      st_z ct_z 0;
      0 0 1];

step = 20;
f = figure;
F(step) = struct('cdata',[],'colormap',[]);

% Pin-hole Projection
f.Visible = 'off';

% Rotation Matrix from min to max angle along x-axis
for i = 1:step
    a_aux = rx(1) + rx(2).*(i/step);
    a = a_aux * pi/180;

    ct = cos(a);
    st = sin(a);
    
    % Rx = [1 0 0; 
    %       0 ct -st; 
    %       0 st ct];

    % Ry = [ct 0 st;
    %       0 1 0;
    %       -st 0 ct];

    Rz = [ct -st 0;
          st ct 0;
          0 0 1];
    
    R = Rz * Ry * Rx;
    P = K * [R t];
    m = P * M;

    % Plot movie frame
    plot(m(1,:), m(2,:));
    xlim([-3 3]);
    ylim([-3 3]);
    F(i) = getframe;
end
f.Visible = 'on';

% Display Points and Projection
figure(1);
plot3(M(1,:),M(2,:),M(3,:));
hold on
scatter3(t(1), t(2), t(3));
hold off
axis equal; box on; grid on

% Display Movie
figure(2);
movie(F, 10, 10)