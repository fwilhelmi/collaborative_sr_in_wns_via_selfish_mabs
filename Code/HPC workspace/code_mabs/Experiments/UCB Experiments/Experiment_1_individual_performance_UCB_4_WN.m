%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploiting Spatial Reuse in Wireless Networks through Decentralised MABs
% F. Wilhelmi, B. Bellalta, A. Jonsson, C. Cano, G. Neu, S. Barrachina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXPERIMENT EXPLANATION:
% By using a simple grid of 4 WLANs sharing 2 channels, we want to test the
% UCB method if using different numbers of iterations.

clc
clear all

% Add paths to methods folders
addpath(genpath('Power Management Methods/'));
addpath(genpath('Throughput Calculation Methods/'));
addpath(genpath('Network Generation Methods/'));
addpath(genpath('Reinforcement Learning Methods/'));
addpath(genpath('Reinforcement Learning Methods/Action Selection Methods/'));
addpath(genpath('Auxiliary Methods/'));

disp('-----------------------')
disp('UCB: Throughput Evolution')
disp('-----------------------')

% Generate constants from 'constants.m'
constants

% Setup the scenario: generate WLANs and initialize states and actions
wlans = generate_network_3D(nWlans, 'grid', 2, 0); % SAFE CONFIGURATION
    
policy = UCB_POLICY;
% Compute the throughput experienced per WLAN at each iteration
[tptEvolutionPerWlan, timesArmHasBeenPlayed] = ucb(wlans);

% Plot the results
if plotResults
    display_results_individual_performance(wlans, tptEvolutionPerWlan, timesArmHasBeenPlayed, 'UCB');
end

% Save the workspace
save('./Output/ucb_exp1_workspace.mat')