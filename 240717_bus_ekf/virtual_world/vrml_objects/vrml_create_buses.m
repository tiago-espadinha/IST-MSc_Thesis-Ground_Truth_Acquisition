function vrml_create_buses

%VRML_CREATE_BUSES - Create four vrml buses
%
% Define buses as boxes with size 1x1x5
%
%     4----3
%    /|   /|       z
%   1----2 |      /
%   | 8--|-7     /
%   |/   |/     +--- x
%   5----6      |
%               |
%               y
%
% Syntax: vrml_create_buses
%
% Inputs: none
%
% Outputs: none
%
% Other files required: bus1.png, bus2.png, bus3.png, bus4.png
% Subfunctions: none
% MAT-files required: vrml_textured_model

% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% March 2013; Last revision: 11-Mar-2013

%------------- BEGIN CODE ---------------

xyz= [...
   0 0 0
   1 0 0
   1 0 5
   0 0 5
   0 1 0
   1 1 0
   1 1 5
   0 1 5
]';


% define faces (polygons) of the 3D object
%
polygons= {...
[1 4 3 2], ... % bus top
[1 2 6 5], ... % bus back
[2 3 7 6], ... % bus right
[3 4 8 7], ... % bus front
[4 1 5 8]...   % bus left
};


% define texture for each polygon by giving for each
% polygon vertex a 2D point in a texture image
% use x=clickpts to find the points

uv1 = [...
    76.8494   88.9631
    402.8438   88.9631
    402.8438  157.1449
    76.8494  157.1449
    404.2642  157.1449
    473.1563  156.4347
    473.1563  234.5597
    404.9744  233.1392
    405.6847   88.9631
    69.0369   88.2528
    68.3267    0.8949
    405.6847    0.8949
    0.8551  156.4347
    69.7472  156.4347
    69.7472  238.1108
    0.8551  238.8210
    69.0369  157.1449
    403.5540  157.1449
    404.9744  245.9233
    69.0369  245.9233
]';

uv2 = [...
    245.6552 263.368
    1298.3219 265.3694
    1298.3219 469.4987
    245.6552 469.4987
    1298.3219 471.5000
    1506.4537 469.4987
    1506.4537 701.6457
    1300.3231 701.6457
    1304.3257 265.3694
    203.6286 263.3681
    203.6286 1.2021
    1304.3257 1.2021
    1.5006  467.4975
    205.6299  469.4987
    205.6299  713.6534
    1.5006  713.6534
    205.6299 471.5000
    1298.3219 471.5000
    1302.3244 735.6673
    205.6299 735.6673    
]';

uv3 = [...
    255.6611 321.4184
    1326.3375 323.4197
    1328.3388 573.5777
    257.6624 573.5777
    1330.3400 573.5777
    1582.4993 571.5764
    1583.5006 901.7850
    1330.3400 899.7838
    1334.3426 323.4197
    259.6637 325.4209
    255.6611 1.216
    1334.3426 0.785
    3.5019  571.5765
    257.6625  573.5777
    255.6612  903.7863
    5.5032  899.7838
    255.6611 575.5790
    1330.3400 573.57771
    1330.3400 901.7850
    257.6624 897.7825
]';

uv4 = [...
    1027.5222 370.4989
    162.9404 370.4989
    161.4393 209.8909
    1027.5222 209.8909
    1027.5222 370.4989
    1186.6292 370.4989
    1188.1303 579.1393
    1027.5222 579.1393
    1027.5222 209.8909
    161.4393 209.8909
    161.4393 1.2505
    1026.0212 1.2505
    0.8313  368.9980
    162.9404 370.4989  
    162.9404  580.6404
    0.8313  580.6404
    162.9404 370.4989
    1027.5222 370.4989
    1027.5222 579.1393
    162.9404  580.6404
]';

% normalize uv to 0..1:

uv1(1,:)= uv1(1,:)/(500+1);
uv1(2,:)= 1-uv1(2,:)/(314+1); % y=0 is in vrml bottom of the image (not top)

uv2(1,:)= uv2(1,:)/(1579+1);
uv2(2,:)= 1-uv2(2,:)/(942+1); % y=0 is in vrml bottom of the image (not top)

uv3(1,:)= uv3(1,:)/(1583+1);
uv3(2,:)= 1-uv3(2,:)/(900+1); % y=0 is in vrml bottom of the image (not top)

uv4(1,:)= uv4(1,:)/(1245+1);
uv4(2,:)= 1-uv4(2,:)/(743+1); % y=0 is in vrml bottom of the image (not top)

% finally create the vrml model (file):

facesList= { polygons, uv1, 'bus1.png' };
modelFileName= 'bus1.wrl';
vrml_textured_model( xyz, facesList, modelFileName )

facesList= { polygons, uv2, 'bus2.png' };
modelFileName= 'bus2.wrl';
vrml_textured_model( xyz, facesList, modelFileName )

facesList= { polygons, uv3, 'bus3.png' };
modelFileName= 'bus3.wrl';
vrml_textured_model( xyz, facesList, modelFileName )

facesList= { polygons, uv4, 'bus4.png' };
modelFileName= 'bus4.wrl';
vrml_textured_model( xyz, facesList, modelFileName )






%------------- END OF CODE -------------
