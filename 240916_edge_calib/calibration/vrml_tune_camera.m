%-------------------------------------------------
%
% VRML_TUNE_CAMERA - Optimizes vehicle pose by matching edges with a real image.
% This function uses `fminsearch` to find the optimal 6-DOF or 7-DOF vehicle
% pose that minimizes the cost function, which is based on the distance
% between edges in the real and rendered images.
%
% Inputs:
%   config : struct : The configuration structure.
%   state  : struct : The state structure.
%
% Outputs:
%   config : struct : The updated configuration structure.
%   state  : struct : The updated state structure with the optimized pose.
%
% Other m-files required: edge_detection.m, vrml_world_set.m, vrml_camera_set.m, save_results.m
% Subfunctions: cam_match_edge, penalty, optimization_plot
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [config, state] = vrml_tune_camera(config, state)

    config.real_edge = edge_detection(config, state.edge_input.car_bbox);
    
    % Setup fminsearch
    options = optimset('Display', 'none', 'MaxFunEvals', 150);
    if config.visualize_optimization
        figure(601); % Create figure for plotting
        options.OutputFcn = @(x, optimValues, fstate) optimization_plot(x, optimValues, fstate, config);
    end

    % Run Optimization
    if strcmp(config.mode, '6dof')
        state.cam_predict = [state.edge_input.car_position, state.edge_input.car_rotation];
    elseif strcmp(config.mode, '7dof')
        state.cam_predict = [state.edge_input.car_position, state.edge_input.car_rotation, state.edge_input.cam_fov];
    end
    fn = @(x) cam_match_edge(x, config) + penalty(x);
    
    car_calib = fminsearch(fn, state.cam_predict, options);
    state.pos_car = car_calib(1:3);
    state.rot_car = car_calib(4:6);
    if strcmp(config.mode, '7dof')
        state.cam_fov = car_calib(7);
    end
    if config.visualize_optimization
        save_results([state.edge_input.name(1:end-4), '_', config.mode]);
    end
end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
% 
% CAM_MATCH_EDGE - Cost function for edge matching optimization.
% 
% Inputs:
%   x      : array  : vehicle pose parameters (and optional FOV)
%   config : struct : configuration structure
% 
% Outputs:
%   F : double : cost value representing the difference between images
% 
%------------- BEGIN FUNCTION ---------------

function F = cam_match_edge(x, config)
    % Set vehicle parameters in VRML worlds
    translation = x(1:3);
    rotation = x(4:6);
    vrml_world_set(config.wnodes, translation, rotation);
    
    if length(x) == 7
        vrml_camera_set(config.wnodes, x(7));
    end
    
    img_vrml = capture(config.world_fig);

    % Detect edges in the test image
    threshold = 10;
    dist_transform = bwdist(edge(rgb2gray(img_vrml)));
    dist_transform(dist_transform > threshold) = threshold;
    edge_transform = config.real_edge .* dist_transform;
    F = sum(sum(edge_transform));
end

%------------- END OF FUNCTION ---------------


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

    [img_height, img_width, ~] = size(config.real_car);
    gray_image = rgb2gray(config.real_car);

    % Determine the threshold for Canny edge detection
    level = graythresh(gray_image);
    canny_threshold = [level/100 level/2];
    config.real_mask = edge(gray_image, 'Canny', canny_threshold);
    [~,~,Gx,Gy] = edge(gray_image, 'Sobel');
    processed_edge = config.real_mask .* sqrt(Gx.^2 + Gy.^2);

    % Calculate the bounding box coordinates
    x_min = round(max(1, bbox(1) - bbox(3)/2));
    x_max = round(min(img_width, bbox(1) + bbox(3)/2));
    y_min = round(max(1, bbox(2) - bbox(4)/2));
    y_max = round(min(img_height, bbox(2) + bbox(4)/2));

    % Create a mask for the bounding box
    mask = zeros(img_height, img_width);
    mask(y_min:y_max, x_min:x_max) = true;

    % Apply the mask: Set all values outside the bounding box to zero
    processed_edge(~mask) = 0;
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
% 
% PENALTY - Penalty function to constrain optimization.
% 
% Inputs:
%   x : array : vehicle pose parameters
% 
% Outputs:
%   penalty : double : infinity if constraints are violated, otherwise zero
% 
%------------- BEGIN FUNCTION ---------------

function penalty_val = penalty(x)
    lb = -pi/10;
    ub =  pi/10;
    if x(5)<lb || x(5)>ub || x(6)<lb || x(6)>ub
        penalty_val = inf;
    else
        penalty_val = 0;
    end
end

%------------- END OF FUNCTION ---------------


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
        
        figure(601);
        subplot(2, 3, 1); 
        imshow(config.real_car);
        title('Real Car Image');
        
        subplot(2, 3, 4); 
        imagesc(config.real_edge); axis image; axis off;
        title('Real Car Edges');
    end

    if optimValues.fval < bestF_plot
        bestF_plot = optimValues.fval;
    end

    % Re-capture image for plotting
    translation = x(1:3);
    rotation = x(4:6);
    vrml_world_set(config.wnodes, translation, rotation);
    if length(x) == 7
        vrml_camera_set(config.wnodes, x(7));
    end
    img_vrml = capture(config.world_fig);
    overlay = double(config.real_car) .* double(img_vrml);
    overlay = overlay / max(overlay(:));
    threshold = 10;
    dist_transform = bwdist(edge(rgb2gray(img_vrml))); 
    dist_transform(dist_transform > threshold) = threshold;
    edge_transform = config.real_edge .* dist_transform;

    % Update Plots
    figure(601);
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