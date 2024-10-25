%-------------------------------------------------
%
% EDGE_POSE - Estimates vehicle pose by matching edges from a VRML model.
% This function takes a predicted vehicle pose and refines it by finding the
% optimal pose that minimizes the difference between a rendered VRML vehicle
% image and the detected edges in the real video frame. It uses fminsearch
% for the optimization.
%
% Inputs:
%   config   : struct : Configuration parameters, including VRML world nodes and images.
%   xyt_pred : vector : Predicted pose of the vehicle [x, y, theta].
%
% Outputs:
%   xyt_meas : vector : The optimized vehicle pose measurement [x, y, theta].
%
% Other m-files required: vrml_world_set.m
% Subfunctions: edge_cost, edge_detection, optimization_plot
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 21-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function xyt_meas = edge_pose(config, xyt_pred)

    config.real_edge = edge_detection(config, config.bboxArray(config.bboxIdx(1)));

    % Setup fminsearch
    options = optimset('Display', 'none');
    if config.visualize_optimization
        figure(702); % Create figure for plotting
        options.OutputFcn = @(x, optimValues, fstate) optimization_plot(x, optimValues, fstate, config);
    end
    % Edge matching optimization
    fn = @(x) edge_cost(x, config);
    xyt_meas = fminsearch(fn, xyt_pred', options);
end

%------------- END OF MAIN FUNCTION --------------


%--------------------------------------------
%
% EDGE_COST - Applies edge detection to a VRML image and calculates an edge matching score.
% This function updates the VRML vehicle position, detects edges in the
% rendered image, and computes a cost based on the distance transform of
% the real image edges.
%
% Inputs:
%   xyt    : vector : Vehicle state [x, y, theta].
%   config : struct : Configuration parameters, including VRML world and real edge image.
%
% Outputs:
%   F      : double : The edge matching score (cost).
%
%------------- BEGIN FUNCTION ---------------

function F = edge_cost(xyt, config)
    xyt(3) = xyt(3)-1.57;
    % Update VRML vehicle position
    vrml_world_set(config.wnodes, xyt);
    img_vrml = capture(config.world_fig);

    % Detect edges in the test image
    threshold = 10;
    dist_transform = bwdist(edge(rgb2gray(img_vrml)));
    dist_transform(dist_transform > threshold) = threshold;
    edge_transform = config.real_edge .* dist_transform;
    F = sum(sum(edge_transform));
end

%------------- END OF FUNCTION --------------


%--------------------------------------------
%
% EDGE_DETECTION - Detects edges in the input image using Canny edge detection.
%
% Inputs:
%   config : struct : configuration structure containing the images and settings
%   bbox   : array  : bounding box coordinates
%
% Outputs:
%   processed_edge : 2D array : binary image with detected edges
%
%------------- BEGIN FUNCTION ---------------
 
function processed_edge = edge_detection(config, bbox)

    [img_height, img_width, ~] = size(config.vidFrame);
    gray_image = rgb2gray(config.vidFrame);

    % Determine the threshold for Canny edge detection
    level = graythresh(gray_image);
    canny_threshold = [level/100 level/2];
    config.real_mask = edge(gray_image, 'Canny', canny_threshold);
    [~,~,Gx,Gy] = edge(gray_image, 'Sobel');
    processed_edge = config.real_mask .* sqrt(Gx.^2 + Gy.^2);

    % Calculate the bounding box coordinates
    x_min = round(max(1, bbox.x - bbox.w*1.3/2));
    x_max = round(min(img_width, bbox.x + bbox.w*1.3/2));
    y_min = round(max(1, bbox.y - bbox.h*1.3/2));
    y_max = round(min(img_height, bbox.y + bbox.h*1.3/2));

    % Create a mask for the bounding box
    mask = zeros(img_height, img_width);
    mask(y_min:y_max, x_min:x_max) = true;

    % Apply the mask: Set all values outside the bounding box to zero
    processed_edge(~mask) = 0;
end

%------------- END OF FUNCTION --------------


%--------------------------------------------
% 
% OPTIMIZATION_PLOT - Output function for fminsearch to plot progress.
%
% Inputs:
%   x           : array  : current parameter values
%   optimValues : struct : structure containing information about the optimization state
%   fstate      : string : state of the optimization ('init', 'iter', 'done', 'interrupt')
%   config      : struct : configuration structure
%
% Outputs:
%   stop : boolean : true to stop optimization, false to continue
% 
%------------- BEGIN FUNCTION ---------------

function stop = optimization_plot(x, optimValues, fstate, config)
    stop = false;
    if ~strcmp(fstate, 'iter')
        return;
    end

    persistent bestF_plot;
    if optimValues.iteration == 0
        bestF_plot = inf;
        
        figure(702);
        subplot(2, 3, 1)
        imshow(config.vidFrame); hold on;
        rectangle('Position', [config.bboxArray(config.bboxIdx(1)).x - config.bboxArray(config.bboxIdx(1)).w*1.3/2, ...
            config.bboxArray(config.bboxIdx(1)).y - config.bboxArray(config.bboxIdx(1)).h*1.3/2, ...
            config.bboxArray(config.bboxIdx(1)).w*1.3, config.bboxArray(config.bboxIdx(1)).h*1.3], ...
            'EdgeColor', 'r', 'LineWidth', 2);
        title(['Frame: ', num2str(optimValues.iteration)]);
        
        subplot(2, 3, 4); 
        imagesc(config.real_edge); axis image; axis off; hold on;
        rectangle('Position', [config.bboxArray(config.bboxIdx(1)).x - config.bboxArray(config.bboxIdx(1)).w*1.3/2, ...
            config.bboxArray(config.bboxIdx(1)).y - config.bboxArray(config.bboxIdx(1)).h*1.3/2, ...
            config.bboxArray(config.bboxIdx(1)).w*1.3, config.bboxArray(config.bboxIdx(1)).h*1.3], ...
            'EdgeColor', 'r', 'LineWidth', 2);
        title('Real Car Edges');
    end

    if optimValues.fval < bestF_plot
        bestF_plot = optimValues.fval;
    end

    % Re-capture image for plotting
    vrml_world_set(config.wnodes, x);
    img_vrml = capture(config.world_fig);
    overlay = double(config.vidFrame) .* double(img_vrml);
    overlay = overlay / max(overlay(:));
    threshold = 10;
    dist_transform = bwdist(edge(rgb2gray(img_vrml))); 
    dist_transform(dist_transform > threshold) = threshold;
    edge_transform = config.real_edge .* dist_transform;

    % Update Plots
    figure(702);
    subplot(2, 3, 2); 
    imshow(img_vrml);
    title('VRML Car Image');

    subplot(2, 3, 3);
    imagesc(overlay); axis image; axis off
    title('Image Overlay');

    subplot(2, 3, 5); 
    imagesc(dist_transform); axis image; axis off
    title({['VRML Edges'] ['Distance Transform']})

    subplot(2, 3, 6)
    imagesc(edge_transform); axis image; axis off
    title({['Intersection Mask']
        ['     f-val = ', num2str(optimValues.fval, 3)]
        ['Best f-val = ', num2str(bestF_plot, 3)]})

    drawnow;
end

%------------- END OF FUNCTION --------------