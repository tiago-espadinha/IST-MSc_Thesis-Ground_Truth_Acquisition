%-------------------------------------------------
%
% PROCESS_IMAGES - Processes a series of vehicle images to find and plot vehicle positions.
% This function iterates through a list of images, and for each one, it either
% prompts the user to select wheel points or uses pre-existing data. It then
% transforms these points to a BEV perspective and calculates the vehicle's center.
%
% Inputs:
%   config : struct : Configuration structure with file paths, images, and flags.
%   H      : matrix : 3x3 homography matrix.
%
% Outputs:
%   None
%
% Other m-files required: calculate_center.m, clickpts.m, save_results.m
% Subfunctions: None
% MAT-files required: 
%   - File from config.path_img_names (contains image names)
%   - File from config.path_bev_coord (optional, contains wheel/center coordinates)
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% October 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function process_images(config, H)

    % Image array ordered for consistent plotting
    load(config.path_img_names, 'img_name_array');
    num_images = numel(img_name_array);

    if config.compute_wheel_coords
        coords_bev.wheel_in_arr = zeros(2*num_images, 2);
        coords_bev.wheel_out_arr = zeros(2*num_images, 2);
        coords_bev.center_arr = zeros(num_images, 2);
    else
        load(config.path_bev_coord, 'wheel_in_arr', 'wheel_out_arr', 'center_arr');
        coords_bev.wheel_in_arr = wheel_in_arr;
        coords_bev.wheel_out_arr = wheel_out_arr;
        coords_bev.center_arr = center_arr;
    end

    % Prepare figures for plotting
    figure(601); clf;
    title('Original Vehicle Images with Wheel Points');

    % Process each image
    for i = 1:num_images
        current_image_path = img_name_array{i};
        
        if config.compute_wheel_coords
            % Manually select wheel points on the current image
            figure(601);
            imshow(current_image_path);
            title(['Select 2 wheel points for: ' strrep(img_name_array{i}, '_', '\_')]);
            wheel_in = clickpts;
            coords_bev.wheel_in_arr(2*i-1:2*i,:) = wheel_in;

            % Transform points to BEV
            wheel_out = tformfwd(H, wheel_in(:,1), wheel_in(:,2));
            coords_bev.wheel_out_arr(2*i-1:2*i,:) = wheel_out;
            
            % Calculate vehicle center
            center = calculate_center(wheel_out);
            coords_bev.center_arr(i,:) = center;
        else
            % Use pre-loaded data
            wheel_in = coords_bev.wheel_in_arr(2*i-1:2*i, :);
            
            % Display original image and wheel points
            figure(601);
            subplot(3, 3, i);
            imshow(current_image_path);
            hold on;
            plot(wheel_in(:,1), wheel_in(:,2), '+', 'MarkerSize', 3, 'LineWidth', 3);
            title(strrep(img_name_array{i}, '_', '\_'), 'FontSize', 8);
        end
    end

    % Plot wheel points and vehicle center on VRML floor and BEV images
    figure(602); clf;
    imshow(config.img_floor); hold on; 
    title('Vehicle Positions on VRML Floor');

    figure(603); clf;
    imshow(config.bev_car); hold on;
    title('Vehicle Positions on BEV Image');

    for i = 1:num_images
        wheel_out = coords_bev.wheel_out_arr(2*i-1:2*i, :);
        center = coords_bev.center_arr(i, :);

        for fig_num = [602, 603]
            figure(fig_num);
            h_wheel = plot(wheel_out(:,1), wheel_out(:,2), '+', 'MarkerSize', 10, 'LineWidth', 3);
            h_center = plot(center(1), center(2), 'o', 'MarkerSize', 10, 'LineWidth', 3);
            h_center.Color = h_wheel.Color;

            dummy_wheel = plot(nan, nan, 'black+', 'MarkerSize', 10, 'LineWidth', 3);
            dummy_center = plot(nan, nan, 'blacko', 'MarkerSize', 10, 'LineWidth', 3);
            legend([dummy_wheel, dummy_center], {'Vehicle Wheels', 'Vehicle Center'});
        end
    end

    if config.compute_wheel_coords
        save_results(config.path_bev_coord, coords_bev);
    end
end

%------------- END OF MAIN FUNCTION --------------