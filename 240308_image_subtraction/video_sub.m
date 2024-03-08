%-------------------------------------------------
%
% VIDEO_SUB - Removes the background of a video, generating a subtraction video and a mask video.
% This function processes a video frame by frame, performing background subtraction
% using a specified background image and threshold. It produces two outputs: a video
% showing the subtracted result and a binary mask video. Optionally, it can use a
% bounding box mask from external data to refine the foreground detection.
%
% Inputs:
%   video_path       : string : Path to the video to be processed.
%   background_path  : string : Path to the background image.
%   threshold        : double : Threshold value for background removal (0-1).
%   output_sub_path  : string : Path to save the output subtraction video.
%   output_mask_path : string : Path to save the output mask video.
%   varargin         : cell   : Optional arguments for bounding box masking:
%                               - track_id: int : ID of the track to process.
%                               - bbox_data_path: string : Path to the .mat file
%                                 containing bounding box data.
%
% Outputs:
%   output_sub_video  : file : A video showing the result of the background subtraction.
%   output_mask_video : file : A binary mask video of the foreground objects.
%
% Other m-files required: create_bbox_mask_video.m, save_results.m
% Subfunctions: None
% MAT-files required: The .mat file specified by bbox_data_path (if used).
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% March 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function video_sub(video_path, background_path, threshold, output_sub_path, output_mask_path, varargin)

    % Parse optional arguments
    use_bbox_mask = false;
    if nargin > 5
        track_id = varargin{1};
        bbox_data_path = varargin{2};
        use_bbox_mask = true;
    end

    % Load video and background
    video = VideoReader(video_path);
    background_g = rgb2gray(imread(background_path));

    % Create subtraction output video
    output_sub_path = save_results(output_sub_path);
    vidsubVideo = VideoWriter(output_sub_path, 'MPEG-4');
    vidsubVideo.FrameRate = video.FrameRate;
    open(vidsubVideo)

    % Create mask output video
    output_mask_path = save_results(output_mask_path);
    maskVideo = VideoWriter(output_mask_path, 'MPEG-4');
    maskVideo.FrameRate = video.FrameRate;
    open(maskVideo);

    % Create bounding box mask video if specified
    video_bbox = []; % Initialize video_bbox
    if use_bbox_mask
        vid_dims = [video.Height, video.Width];
        vid_num_frames = video.NumFrames;
        bbox_mask_path = 'bbox_mask.mp4';
        generated_bbox_mask_path = create_bbox_mask_video(bbox_data_path, track_id, vid_dims, vid_num_frames, bbox_mask_path);
        if ~isempty(generated_bbox_mask_path)
            video_bbox = VideoReader(generated_bbox_mask_path);
            % Check if the generated video actually has frames
            if video_bbox.NumFrames == 0
                use_bbox_mask = false;
                warning('VIDEO_SUB: Generated bounding box mask video is empty. Proceeding without it.');
            end
        else
            % If bbox mask video generation failed, disable its use
            use_bbox_mask = false;
            warning('VIDEO_SUB: Bounding box mask video could not be generated. Proceeding without it.');
        end
    end

    % Process each frame
    while hasFrame(video)
        frame = readFrame(video);
        frame_g = rgb2gray(frame);

        % Perform background subtraction
        vidsub = abs(imsubtract(frame_g, background_g));
        mask = vidsub > threshold * 255;

        % Apply bounding box mask if specified
        if use_bbox_mask
            % Check if video_bbox still has frames before reading
            if hasFrame(video_bbox)
                frame_bbox = readFrame(video_bbox);
                frame_bbox_g = rgb2gray(frame_bbox);
                vidsub = vidsub .* uint8(frame_bbox_g > 0);
                mask = mask & (frame_bbox_g > 0);
            else
                % If video_bbox runs out of frames prematurely, disable bbox mask
                use_bbox_mask = false;
                warning('VIDEO_SUB: Bounding box mask video ran out of frames prematurely. Disabling bbox mask.');
            end
        end

        % Write the mask to the output video
        writeVideo(vidsubVideo, vidsub);
        writeVideo(maskVideo, uint8(mask) * 255);
    end

    close(vidsubVideo);
    close(maskVideo);
end

%------------- END OF MAIN FUNCTION --------------