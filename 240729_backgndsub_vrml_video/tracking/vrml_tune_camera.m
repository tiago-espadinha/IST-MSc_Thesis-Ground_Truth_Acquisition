%-------------------------------------------------
%
% VRML_TUNE_CAMERA - Optimizes VRML camera parameters to match a real image.
% This function fine-tunes the VRML camera's parameters (e.g., position, FOV)
% by minimizing the difference between the edges of a real-world image and
% the edges of the rendered image from the VRML world.
%
% Inputs:
%   config : struct : The configuration structure.
%   state  : struct : The state structure.
%
% Outputs:
%   config : struct : The updated configuration structure.
%   state  : struct : The updated state structure with camera parameters.
%
% Other m-files required: vrml_camera_get.m, vrml_camera_set.m
% Subfunctions: edge_cost, edge_detection, optimization_plot
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% July 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function [config, state] = vrml_tune_camera(config, state)

    config.real_edge = edge_detection(config);

    % Setup fminsearch
    options = optimset('Display', 'none', 'MaxFunEvals', 150);
    if config.visualize_optimization
        figure(301); % Create figure for plotting
        options.OutputFcn = @(x, optimValues, fstate) optimization_plot(x, optimValues, fstate, config);
    end

    % Edge matching optimization
    state.cam_predict = vrml_camera_get(config.wnodes);
    fn = @(x) edge_cost(x, config);
    state.cam_update = fminsearch(fn, state.cam_predict, options);
end

%------------- END OF MAIN FUNCTION --------------


%--------------------------------------------
%
% EDGE_POSE - Computes the cost function for camera tuning in VRML
% This function processes the current VRML image by:
%   - Detecting edges in the VRML image.
%   - Applying a distance transform to the detected edges.
%   - Saturating the resulting distance transform.
%   - Computing the difference between the saturated 
%       distance transform and the edges detected
%
% Inputs:
%   x : vector : camera parameters [fov, tx, ty, tz, ra, rb, rc]
%   config : struct : configuration structure containing project settings
%
% Outputs:
%   F : scalar : cost value
%
%------------- BEGIN FUNCTION ---------------

function F = edge_cost(x, config)

    % Update VRML camera position
    vrml_camera_set(config.wnodes, x);
    im_tst = capture(config.world_fig);

    % Detect edges in the test image
    threshold = 10;
    dist_transform = bwdist(edge(rgb2gray(im_tst))); 
    dist_transform(dist_transform > threshold) = threshold;
    edge_transform = config.real_edge .* dist_transform;
    F = sum(sum(edge_transform));
end

%------------- END OF FUNCTION --------------


%--------------------------------------------
%
% EDGE_DETECTION - Detects edges in the input image using Canny edge detection
%
% Inputs:
%   config : struct : configuration structure containing the images and settings
%
% Outputs:
%   processed_edge : 2D array : binary image with detected edges
%
%------------- BEGIN FUNCTION ---------------

function processed_edge = edge_detection(config)

    gray_image = rgb2gray(config.real_car);

    if config.edge_detection == 1
        % Adjust the contrast of the grayscale image
        gray_image = imadjust(gray_image);
        gray_image = imgaussfilt(gray_image, 2);

        % Determine the threshold for Canny edge detection
        level = graythresh(gray_image);
        canny_threshold = [level/100 level/2];
        processed_edge = edge(gray_image, 'Canny', canny_threshold);

    elseif config.edge_detection == 2
        if exist('config.real_mask', 'var') && ~isempty(config.real_mask)
            % Use the provided mask to filter edges
            [~,~,Gx,Gy] = edge(gray_image,'Sobel');
            processed_edge = config.real_mask .* sqrt( Gx.^2 + Gy.^2 );
        else
            % Determine the threshold for Canny edge detection
            level = graythresh(gray_image);
            canny_threshold = [level/100 level/2];
            config.real_mask = edge(gray_image, 'Canny', canny_threshold);
            [~,~,Gx,Gy] = edge(gray_image,'Sobel');
            processed_edge = config.real_mask .* sqrt( Gx.^2 + Gy.^2 );
        end
    end
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
        
        figure(301);
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
    vrml_camera_set(config.wnodes, x);
    img_vrml = capture(config.world_fig);
    overlay = double(config.real_car) .* double(img_vrml);
    overlay = overlay / max(overlay(:));
    threshold = 10;
    dist_transform = bwdist(edge(rgb2gray(img_vrml))); 
    dist_transform(dist_transform > threshold) = threshold;
    edge_transform = config.real_edge .* dist_transform;

    % Update Plots
    figure(301);
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