%-------------------------------------------------
% 
% CHECK_INPUT_DATA - Interactively validates and updates calibration input data.
% This script allows the user to visually inspect each frame's initial pose
% guess and bounding box and provides prompts to update them if necessary.
% 
% Inputs:
%   None
% 
% Outputs:
%   None (modifies calibration_input.mat on user confirmation).
% 
% Other m-files required: vrml_world_init.m, vrml_world_set.m, vrml_world_end.m
% Subfunctions: display_input_data, prompt_for_updates
% MAT-files required: calibration_input.mat
% 
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
% 
%------------- BEGIN MAIN FUNCTION ---------------

function check_input_data()

    config.vrml_world = 'vr_world.wrl';
    config.calib_input = 'calibration_input.mat';
    
    %% Load Data
    fprintf('Loading calibration input data from %s...\n', config.calib_input);
    try
        load(config.calib_input, 'edge_input');
    catch ME
        fprintf('Error loading %s.\n', config.calib_input);
        rethrow(ME);
    end

    %% Initialize VRML World
    config = vrml_world_init(config);
    sz = size(config.vrml_backgnd);
    H = sz(1); W = sz(2);
    fprintf('VRML world resolution detected as %d x %d.\n', W, H);

    %% Process Each Frame
    for i = 1:numel(edge_input)
        fprintf('\n--- Displaying Frame %d of %d: %s ---\n', i, numel(edge_input), edge_input(i).name);
        
        % Load and resize real image
        image_path = fullfile('assets', edge_input(i).name);
        if ~exist(image_path, 'file')
            fprintf('Warning: Image not found. Skipping.\n');
            continue;
        end
        resized_image = imresize(imread(image_path), [H, W]);
        
        % Create figure and display images
        figure(605); clf;
        set(gcf, 'Name', sprintf('Frame %d: %s', i, edge_input(i).name));
        display_input_data(resized_image, edge_input(i), config.wnodes, config.world_fig); 
        
        %% Prompt for updates
        needs_update = true;
        while needs_update
            update_choice = input('Update this frame? [y/n/q(quit)]: ', 's');
            switch lower(update_choice)
                case 'y'
                    edge_input(i) = prompt_for_updates(edge_input(i));
                    display_input_data(resized_image, edge_input(i), config.wnodes, config.world_fig); % Redisplay with new values
                case 'n'
                    needs_update = false;
                case 'q'
                    vrml_world_end(); fprintf('\nCheck aborted. No changes will be saved.\n'); return;
                otherwise
                    disp('Invalid input. Please enter y, n, or q.');
            end
        end
    end
    
    %% Clean up and save
    vrml_world_end();
    
    save_choice = input(sprintf('\nAll frames checked. Save changes to %s? [y/n]: ', config.calib_input), 's');
    if strcmpi(save_choice, 'y')
        save(config.calib_input, 'edge_input');
        fprintf('Updated frame data saved to %s\n', config.calib_input);
    else
        fprintf('Changes were not saved.\n');
    end
    
    disp('Check complete.');
end

%------------- END OF MAIN FUNCTION ---------------


%--------------------------------------------
% 
% DISPLAY_INPUT_DATA - Displays the real image with bbox and the VRML view.
% 
% Inputs:
%   resized_image   : array  : The resized real image.
%   edge_input_data : struct : The edge input data for the current frame.
%   wnodes          : struct : VRML world nodes for updating car pose.
%   fig_vr          : handle : VRML figure handle for capturing the view.
% 
% Outputs:
%   None
% 
%------------- BEGIN FUNCTION ---------------

function display_input_data(resized_image, edge_input_data, wnodes, fig_vr)
    
    subplot(1, 2, 1);
    imshow(resized_image);
    hold on;
    bbox = edge_input_data.car_bbox;
    rectangle_pos = [bbox(1) - bbox(3)/2, bbox(2) - bbox(4)/2, bbox(3), bbox(4)];
    rectangle('Position', rectangle_pos, 'EdgeColor', 'r', 'LineWidth', 2, 'LineStyle', '--');
    title({'Resized Real Image', 'with Bounding Box'}, 'Interpreter', 'none');
    hold off;

    vrml_world_set(wnodes, edge_input_data.car_position, edge_input_data.car_rotation);
    vrdrawnow;
    vrml_image = capture(fig_vr);
    
    overlay = double(resized_image) .* double(vrml_image);
    overlay = overlay / max(overlay(:));
    
    subplot(1, 2, 2);
    imshow(overlay);
    title({'VRML View', 'Initial Pose Guess'});
end

%------------- END OF FUNCTION ---------------


%--------------------------------------------
% 
% PROMPT_FOR_UPDATES - Prompts user to enter new values for bbox and pose.
% 
% Inputs:
%   edge_input_data : struct : The edge input data for the current frame.
% 
% Outputs:
%   edge_input_data : struct : The updated edge input data.
% 
%------------- BEGIN FUNCTION ---------------

function edge_input_data = prompt_for_updates(edge_input_data)
    
    disp('Current BBox [cx, cy, w, h]:');
    disp(edge_input_data.car_bbox);
    new_bbox_str = input('Enter new BBox or press Enter to skip: ', 's');
    if ~isempty(new_bbox_str)
        new_vals = str2num(new_bbox_str);
        if numel(new_vals) == 4
            edge_input_data.car_bbox = new_vals;
            disp('BBox updated.');
        else
            disp('Invalid input. BBox not updated.');
        end
    end
    
    disp('Current Pose [x, y, z, r, p, y]:');
    disp([edge_input_data.car_position, edge_input_data.car_rotation]);
    new_input_str = input('Enter new Pose or press Enter to skip: ', 's');
    if ~isempty(new_input_str)
        new_vals = str2num(new_input_str);
        if numel(new_vals) == 6
            edge_input_data.car_position = new_vals(1:3);
            edge_input_data.car_rotation = new_vals(4:6);
            disp('Pose updated.');
        else
            disp('Invalid input. Pose not updated.');
        end
    end
end

%------------- END OF FUNCTION --------------