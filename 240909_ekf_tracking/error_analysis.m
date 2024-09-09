%-------------------------------------------------
%
% ERROR_ANALYSIS - Analyzes and visualizes the EKF tracking error.
% This script loads the simulation results and runs several functions to
% calculate error metrics and plot trajectory comparisons and animations.
%
% Inputs:
%   None
%
% Outputs:
%   None
%
% Other m-files required: config.m, error_metrics.m,
%   plot_trajectory_comparison.m, plot_trajectory_animation.m
% Subfunctions: None
% MAT-files required: The output file specified in config.m
%
% Author: Tiago Simões
% Project: VIENA
% Instituto Superior Técnico
% September 2024; Last revision: 9-September-2025
%
%------------- BEGIN MAIN FUNCTION ---------------

function error_analysis()

    cfg = config();

    error_metrics(cfg.error_out_file)
    plot_trajectory_comparison(cfg.error_out_file)
    plot_trajectory_animation(cfg.error_out_file)
end

%------------- END OF MAIN FUNCTION --------------