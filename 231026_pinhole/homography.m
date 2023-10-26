% Define the source and destination points on the planar surface
%srcPoints = [250, 750; 250, 150; 500, 750; 500, 150]; % Coordinates on the planar surface
%dstPoints = [150, 850; 150, 50; 600, 850; 600, 50]; % Corresponding coordinates in bird's eye view

srcPoints = [470, 310; 130, 700; 1420, 300; 1880, 700];
dstPoints = [320, 50; 715, 1030; 1600, 50; 1480, 1030];

% Load the video
vid_path = 'C:/Users/Tiago/Desktop/Tese_Media/Viena_Tracker_25.avi';
vid = VideoReader(vid_path, 'CurrentTime', 4.5);
frame = readFrame(vid);

% Calculate LUT
LUT = my_homography('LUT_calc',  frame, srcPoints, dstPoints, struct('crop2box', dstPoints));
frame_bev = my_homography('LUT_apply',  LUT, frame);

% Loop through video frames
while hasFrame(vid)
    frame = readFrame(vid);

    % Apply LUT on each frame
    frame_bev = my_homography('LUT_apply',  LUT, frame);

    % Display the bird's eye view frame
    imshow(frame_bev);
end