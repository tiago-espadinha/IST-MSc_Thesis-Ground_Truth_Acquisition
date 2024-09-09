%-------------------------------------------------
%
% BACKGNDSUB - Estimates vehicle pose using background subtraction optimization.
% This function takes a predicted vehicle pose and refines it by finding the
% optimal pose that minimizes the difference between a rendered VRML vehicle
% image and a real-world image, based on background subtraction.
%
% Inputs:
%   config   : struct : Configuration parameters, including VRML world nodes and images.
%   xyt_pred : vector : Predicted pose of the vehicle [x, y, theta].
%
% Outputs:
%   xyt_bgs  : vector : The optimized vehicle pose [x, y, theta].
%
% Other m-files required: vrml_world_set.m
% Subfunctions: car_match_bgs, optimization_plot
% MAT-files required: None
%
% Original author: Tiago Castanheira
% Altered by: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function xyt_bgs = backgndsub(config, xyt_pred)

    % Background subtraction
    config.img_sub = sum(abs(config.real_car-config.vrml_backgnd), 3) > 0.6*255;

    % Setup fminsearch
    options = optimset('Display', 'none', 'MaxFunEvals', 150);
    if config.visualize_optimization
        options.OutputFcn = @(x, optimValues, fstate) optimization_plot(x, optimValues, fstate, config);
    end

    % Background subtraction optimization
    xyt_bgs = fminsearch(@(xyt) car_match_bgs(config, xyt), xyt_pred(1:3)');
    xyt_bgs = xyt_bgs';
end

%------------- END OF MAIN FUNCTION --------------


%--------------------------------------------
%
% CAR_MATCH_BGS - Matches the estimated car position with the background.
%
% Inputs:
%   config  : struct : configuration parameters including VRML world nodes and figure
%   bgs_org : image  : original background subtraction mask
%   im_bck  : image  : background image
%   xyt     : vector : estimated vehicle state [x, y, theta]
%
% Outputs:
%   F       : float  : compatibility ratio (1 - intersection/area)
%
%------------- BEGIN FUNCTION ---------------

function F = car_match_bgs(config, xyt)

    % Set car with xyt
    vrml_world_set(config.wnodes, xyt);

    % Take picture
    im_tst = capture(config.world_fig);

    % Apply background subtraction
    bgs_tst = sum(abs(im_tst - config.vrml_backgnd), 3) ~= 0;

    % Compute interseption
    inters = bgs_tst .* config.img_sub;

    % Calculate area
    area_int = sum(sum(inters));
    area_tst = sum(sum(bgs_tst));
    
    % Calculate compatibility racio
    F = 1 - area_int/area_tst;
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

function stop = optimization_plot(xyt, optimValues, fstate, config)
    stop = false;
    if ~strcmp(fstate, 'iter')
        return;
    end

    persistent bestF_plot;
    if optimValues.iteration == 0
        bestF_plot = inf;

        figure(402);
        subplot(2, 3, 1)
        imshow(config.real_car)
        title('Real Vehicle State')

        subplot(2, 3, 2)
        imshow(config.vrml_backgnd)
        title('Real Background')
    
        subplot(2, 3, 3)
        imshow(config.img_sub)
        title({['Real State']
            ['Image Subtraction']})
    end

    if optimValues.fval < bestF_plot
        bestF_plot = optimValues.fval;
    end

    % Re-capture image for plotting
    vrml_world_set(config.wnodes, xyt);
    im_tst = capture(config.world_fig);
    bgs_tst = sum(abs(im_tst - config.vrml_backgnd), 3) ~= 0;
    inters = bgs_tst .* config.im_sub;

    % Update Plots
    figure(402);
    subplot(2, 3, 4)
    imshow(uint8(im_tst))
    title('Estimated Vehicle State')

    subplot(2, 3, 5)
    imshow(bgs_tst)
    title({['Estimated State']
            ['Image Subtraction']})

    subplot(2, 3, 6)
    imshow(inters)
    title({['Intersection Mask']
            ['     F = ', num2str(F, 3)]
            ['Best F = ', num2str(bestF, 3)]})

    drawnow;
end

%------------- END OF FUNCTION --------------