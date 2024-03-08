%-------------------------------------------------
%
% CREATE_BBOX_MASK_VIDEO - Creates a video mask based on bounding box data.
% This function reads bounding box information from a .mat file for a specific
% track ID and generates a binary video mask where the tracked object is present.
%
% Inputs:
%   bbox_data_path : string : Path to the bounding box data (.mat file).
%   track_id       : int    : ID of the track to be processed.
%   vid_dims       : array  : Dimensions of the video frames [height, width].
%   vid_num_frames : int    : Total number of frames in the video.
%   output_path    : string : Path to save the output video mask.
%
% Outputs:
%   bbox_mask_path : string : Path to the generated bounding box mask video.
%
% Other m-files required: save_results.m
% Subfunctions: None
% MAT-files required: The .mat file specified by bbox_data_path.
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% March 2024; Last revision: 9-September-2025
%
%------------- BEGIN FUNCTION ---------------

function bbox_mask_path = create_bbox_mask_video(bbox_data_path, track_id, vid_dims, vid_num_frames, output_path)

    % Initialize output
    bbox_mask_path = '';

    % Check if bbox_data_path exists
    if ~exist(bbox_data_path, 'file')
        warning('CREATE_BBOX_MASK_VIDEO: Bounding box data file not found: %s', bbox_data_path);
        return;
    end

    % Load bounding box data and check for expected fields
    try
        data = load(bbox_data_path);
        if ~isfield(data, 'frame') || ~isfield(data, 'track_id') || ...
           ~isfield(data, 'x') || ~isfield(data, 'y') || ...
           ~isfield(data, 'w') || ~isfield(data, 'h')
            warning('CREATE_BBOX_MASK_VIDEO: Bounding box data file is missing expected fields: %s', bbox_data_path);
            return;
        end

        % Check consistency of data sizes
        num_detections = numel(data.frame);
        if numel(data.track_id) ~= num_detections || ...
           numel(data.x) ~= num_detections || ...
           numel(data.y) ~= num_detections || ...
           numel(data.w) ~= num_detections || ...
           numel(data.h) ~= num_detections
            warning('CREATE_BBOX_MASK_VIDEO: Inconsistent data sizes in bounding box file: %s', bbox_data_path);
            return;
        end

    catch ME
        warning('CREATE_BBOX_MASK_VIDEO: Error loading bounding box data from %s: %s', bbox_data_path, ME.message);
        return;
    end

    % Create output video
    output_path = save_results(output_path);
    maskVideo = VideoWriter(output_path, 'MPEG-4');
    maskVideo.FrameRate = 30; % Assuming 30 FPS for the mask video
    open(maskVideo);

    % Iterate over each frame of the original video
    for current_frame_idx = 1:vid_num_frames
        frame_mask = zeros(vid_dims);

        % Find all entries in data corresponding to the current frame and track_id
        % Note: data.frame, data.track_id, etc., are 1xN arrays where N is total detections
        % We need to find detections for the current frame and the specified track_id
        matching_indices = find(data.frame == current_frame_idx & data.track_id == track_id);

        for j = 1:numel(matching_indices)
            idx_in_data = matching_indices(j);
            x_min = fix(data.x(idx_in_data) - data.w(idx_in_data) / 2);
            y_min = fix(data.y(idx_in_data) - data.h(idx_in_data) / 2);
            x_max = fix(data.x(idx_in_data) + data.w(idx_in_data) / 2);
            y_max = fix(data.y(idx_in_data) + data.h(idx_in_data) / 2);
            
            % Ensure coordinates are within bounds
            x_min = max(1, x_min);
            y_min = max(1, y_min);
            x_max = min(vid_dims(2), x_max);
            y_max = min(vid_dims(1), y_max);

            % Draw bounding box on the mask
            if y_min <= y_max && x_min <= x_max
                frame_mask(y_min:y_max, x_min:x_max) = 1;
            end
        end

        writeVideo(maskVideo, frame_mask);
    end

    close(maskVideo);
    bbox_mask_path = output_path;
end

%------------- END OF FUNCTION --------------