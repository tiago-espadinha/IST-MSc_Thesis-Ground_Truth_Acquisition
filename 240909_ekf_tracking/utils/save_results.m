%-------------------------------------------------
%
% SAVE_RESULTS - Saves data, figures, or images to the 'outputs' directory.
% This function handles saving different types of data to a standardized
% output location, automatically appending a numerical suffix to the filename
% if a file with the same name already exists.
%
% Inputs:
%   filename    : string : The desired name for the output file (e.g., 'result.mat').
%   save_data   : any    : The data to be saved. The type of this argument depends
%                        on what is being saved:
%                        - For .mat files: a struct of data.
%                        - For images (.jpg, .png, .tif): an image matrix.
%                        - For figures (.fig): this argument is omitted.
%
% Outputs:
%   output_path : string : The full path to the saved file.
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function output_path = save_results(filename, save_data)

    % Define file paths relative to the project root
    current_script_dir = fileparts(mfilename('fullpath'));
    project_root = fileparts(current_script_dir);
    output_dir = fullfile(project_root, 'outputs');
    [~, name, ext] = fileparts(filename);
    output_path = fullfile(output_dir, [name ext]);

    % If file exists, add a number suffix
    counter = 1;
    while exist(output_path, 'file')
        output_path = fullfile(output_dir, sprintf('%s_%d%s', name, counter, ext));
        counter = counter + 1;
    end

    % Save variables from struct to .mat file, save figure, or image
    if strcmp(ext, '.mp4') || strcmp(ext, '.avi')
        fprintf('Video saved to %s\n', output_path);
    elseif ~exist('save_data', 'var') || isempty(save_data)
        savefig(output_path);
        fprintf('Figure saved to %s\n', output_path);
    elseif strcmp(ext, '.jpg') || strcmp(ext, '.png') || strcmp(ext, '.tif')
        imwrite(save_data, output_path);
        fprintf('Image saved to %s\n', output_path);
    else
        save(output_path, '-struct', 'save_data');
        fprintf('Data saved to %s\n', output_path);
    end
end

%------------- END OF MAIN FUNCTION --------------
